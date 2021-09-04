#! /usr/bin/env bash


#######################################
# Condition checkers
#######################################
function _value_is_empty() {
  ! [[ "${1}" ]]
}

function _value_equals() {
  [[ "${1}" == "${2}" ]]
}

function _value_matches_regex() {
  echo "${1}" | grep -qE "${2}"
}

function _variable_is_declared() {
  [[ "${1+x}" ]]
}

function _function_is_declared() {
  declare -F | cut -d" " -f3 | grep -q "^${1}$"
}

function _array_has_key() {
  [[ -v "${1}[${2}]" ]]
}

function _args_num_equal() {
  local expected_number

 expected_number="${1}"; shift
  [[ "${#@}" == "${expected_number}" ]]
}

function _stdin_empty() {
  ! read -t 0
}

function _name_is_protected() {
  _value_matches_regex "${1}" "${PROTECTED_NAME_REGEX}"
}

#######################################
# Determine if current method/attribute
#   has been called from other object method
# Arguments:
#   object name
# Returns:
#   0: inside
#   1: outside
#######################################
function _called_from_inside() {
  local object_name
  local internal_method_prefix

  object_name="${1}"; shift
  internal_method_prefix="$(_get_internal_method_name "${object_name}")"

  echo "${FUNCNAME[*]}" | grep -q "${internal_method_prefix}"
}

#######################################
# Asserters
#######################################
function _assert_value_not_empty() {
  if _value_is_empty "${1}"; then
    _throw_error "${2}"
  fi
}

function _assert_value_valid() {
  local value
  local regex
  local error

  value="${1}"; shift
  regex="${1}"; shift
  error="${1}"; shift

  if ! _value_matches_regex "${value}" "${regex}"; then
    _throw_error "${error}" "${value}"
  fi
}

function _assert_object_not_declared() {
  if _function_is_declared "${1}"; then
    _throw_error "${ERRORS[object_declared]}" "${1}"
  fi
}

function _assert_object_declared() {
  if ! _function_is_declared "${1}"; then
    _throw_error "${ERRORS[object_not_declared]}" "${1}"
  fi
}

function _assert_object_name_valid() {
  _assert_value_valid "${1}" "${VALID_OBJECT_NAME_REGEX}" "${ERRORS[invalid_object_name]}"
}

function _assert_attribute_name_not_empty() {
  _assert_value_not_empty "${1}" "${ERRORS[syntax_error]}"
}

function _assert_attribute_name_valid() {
  _assert_value_valid "${1}" "${VALID_ATTRIBUTE_NAME_REGEX}" "${ERRORS[invalid_attribute_name]}"
}

function _assert_attribute_declared() {
  local internal_object_attributes_name

  internal_object_attributes_name="$(_get_internal_attributes_name "${1}")"

  if ! _array_has_key "${internal_object_attributes_name}" "${2}"; then
    _throw_error "${ERRORS[attribute_error]}" "${1}" "${2}"
  fi
}

function _assert_method_name_not_empty() {
  _assert_value_not_empty "${1}" "${ERRORS[syntax_error]}"
}

function _assert_method_name_valid() {
  _assert_value_valid "${1}" "${VALID_METHOD_NAME_REGEX}" "${ERRORS[invalid_method_name]}"
}

function _assert_method_exists() {
  local internal_object_methods_name

  internal_object_methods_name="$(_get_internal_methods_name "${1}")"

  if ! _array_has_key "${internal_object_methods_name}" "${2}"; then
    _throw_error "${ERRORS[method_error]}" "${1}" "${2}"
  fi
}

function _assert_instance_name_not_empty() {
  _assert_value_not_empty "${1}" "${ERRORS[syntax_error]}"
}

function _assert_is_class() {
  local object_type

  object_type="$(_get_type "${1}")"

  if ! _value_equals "${object_type}" "${CLASS_TYPE_NAME}"; then
    _throw_error "${ERRORS[syntax_error]}"
  fi
}

function _assert_can_call() {
  local object_name
  local property_name
  local error

  object_name="${1}"; shift
  property_name="${1}"; shift
  error="${1}"; shift

  if _name_is_protected "${property_name}"; then
    if ! _called_from_inside "${object_name}" "${property_name}"; then
      _throw_error "${error}" "${object_name}" "${property_name}"
    fi
  fi
}

function _assert_can_call_attribute() {
  local object_name
  local attribute_name

  object_name="${1}"; shift
  attribute_name="${1}"; shift

  _assert_can_call "${object_name}" "${attribute_name}" "${ERRORS[protected_attribute]}"
}

function _assert_can_call_method() {
  local object_name
  local method_name

  object_name="${1}"; shift
  method_name="${1}"; shift

  _assert_can_call "${object_name}" "${method_name}" "${ERRORS[protected_method]}"
}

function _assert_owner_found() {
  local object_name
  local property_name
  local property_owner
  local error

  object_name="${1}"; shift
  property_name="${1}"; shift
  property_owner="${1}"; shift
  error="${1}"; shift

  if _value_is_empty "${property_owner}"; then
      _throw_error "${error}" "${object_name}" "${property_name}"
    fi
}

function _assert_method_owner_found() {
  local object_name
  local method_name
  local method_owner

  object_name="${1}"; shift
  method_name="${1}"; shift
  method_owner="${1}"; shift

  _assert_owner_found "${object_name}" "${method_name}" "${method_owner}" "${ERRORS[method_error]}"
}

function _assert_attribute_owner_found() {
  local object_name
  local attribute_name
  local attribute_owner

  object_name="${1}"; shift
  attribute_name="${1}"; shift
  attribute_owner="${1}"; shift

  _assert_owner_found "${object_name}" "${attribute_name}" "${attribute_owner}" "${ERRORS[attribute_error]}"
}

#######################################
# Validators
#######################################
function _validate_attribute_setter_args() {
  # object : attribute something
  if ! _value_equals "${1}" "="; then
    _throw_error "${ERRORS[syntax_error]}"
  # object : attribute =
  elif ! _variable_is_declared "${2}"; then
    _throw_error "${ERRORS[syntax_error]}"
  # object : attribute = value1 *valueN
  elif ! _args_num_equal 2 "${@}"; then
    _throw_error "${ERRORS[syntax_error]}"
  fi
}
