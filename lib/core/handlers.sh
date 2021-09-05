#! /usr/bin/env bash


#######################################
# Route operation to appropriate operation handler
# Operations:
#   :    - attribute-related operation
#   .    - method-related operation
#   " "  - representation operation
#   else - instance construction operation
# Arguments:
#   object name
#   ** kwargs
#######################################
function _handle_input() {
  local object_name

  object_name="${1}"; shift

  case ${1} in
    "") shift; _handle_representation "${object_name}";;
    ":") shift; _handle_attribute "${object_name}" "${@}";;
    ".") shift; _handle_method "${object_name}" "${@}";;
    *) _handle_instance_creation "${object_name}" "${@}";;
  esac
}

#######################################
# Return object representation
# Arguments:
#   object name
# Outputs:
#   writes representation to STDOUT
#######################################
function _handle_representation() {
  local object_name
  local object_type

  object_name="${1}"; shift
  object_type="$(_get_type "${object_name}")"

  case "${object_type}" in
    "${CLASS_TYPE_NAME}") _get_class_representation "${object_name}";;
    "${INSTANCE_TYPE_NAME}") _get_instance_representation "${object_name}";;
  esac
}

#######################################
# Determine and execute attribute operation
# Operations:
#   GET attribute
#   SET attribute
# Arguments:
#   object name
#   attribute name
#   *extra args
# Outputs:
#   GET attribute: writes representation to STDOUT
#######################################
function _handle_attribute() {
  local object_name
  local attribute_name

  local attribute_owner
  local attribute_value

  object_name="${1}"; shift
  attribute_name="${1}"; shift

  _assert_attribute_name_not_empty "${attribute_name}"
  _assert_attribute_name_valid "${attribute_name}"
  _assert_can_call_attribute "${object_name}" "${attribute_name}"

  if _value_is_empty "${1}"; then
    # GET attribute. object : attribute
    attribute_owner="$(_resolve_attribute "${object_name}" "${attribute_name}")"
    _assert_attribute_owner_found "${object_name}" "${attribute_name}" "${attribute_owner}"

    _get_attribute "${attribute_owner}" "${attribute_name}"
  else
    # SET attribute. object : attribute *args
    _validate_attribute_setter_args "${@}"

    attribute_value="${2}"
    _set_attribute "${object_name}" "${attribute_name}" "${attribute_value}"
  fi
}

#######################################
# Determine and execute method operation
# Operations:
#   SET method
#   EXECUTE method
# Arguments:
#   object name
#   method name
#   *extra args
# Outputs:
#   EXECUTE method: writes method output to STDOUT if any
#######################################
function _handle_method() {
  local object_name
  local method_owner
  local method_name
  local method_body

  object_name="${1}"; shift
  method_name="${1}"; shift

  _assert_method_name_not_empty "${method_name}"
  _assert_method_name_valid "${method_name}"

  method_body="$(_read_from_stdin)"

  if _value_is_empty "${method_body}" ; then
    # Method execution
    _assert_can_call_method "${object_name}" "${method_name}"

    method_owner="$(_resolve_method "${object_name}" "${method_name}")"
    _assert_method_owner_found "${object_name}" "${method_name}" "${method_owner}"

    _call_method "${method_owner}" "${method_name}" "${@}"
  else
    # Method declaration
    _set_method "${object_name}" "${method_name}" "${method_body}"
  fi
}

#######################################
# Validate and create a new object of type `instance`
#   copying all attributes and methods of `class`
# Arguments:
#   object name
#   instance name
#######################################
function _handle_instance_creation() {
  local object_name
  local instance_name

  object_name="${1}"; shift
  instance_name="${1}"; shift

  _assert_is_class "${object_name}"
  _assert_instance_name_not_empty "${instance_name}"
  _assert_object_name_valid "${instance_name}"

  _declare_instance "${object_name}" "${instance_name}"
  _call_init_method "${object_name}" "${@}"
}