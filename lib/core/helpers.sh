#! /usr/bin/env bash

#######################################
# Get name of array containing object attributes
#   as in output of `declare`
# Arguments:
#   object name
# Outputs:
#   array name
#######################################
function _get_internal_attributes_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}${ATTRIBUTES_SUFFIX}"
}

#######################################
# Get name of array containing object methods
#   as in output of `declare`
# Arguments:
#   object name
# Outputs:
#   array name
#######################################
function _get_internal_methods_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}${METHODS_SUFFIX}"
}

#######################################
# Get name of a declare function associated
#   with an object method
# Arguments:
#   object name
#   method name
# Outputs:
#   function name
#######################################
function _get_internal_method_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}${METHOD_SUFFIX}${2}"
}

#######################################
# Get attribute of an object
# Arguments:
#   object name
#   attribute name
# Outputs:
#   attribute value
#######################################
function _get_attribute() {

  local object_name
  local attribute_name
  local internal_object_attributes_name

  object_name="${1}"; shift
  attribute_name="${1}"; shift
  internal_object_attributes_name="$(_get_internal_attributes_name "${object_name}")"

  _get_array_value "${internal_object_attributes_name}" "${attribute_name}"
}

#######################################
# Format method body before declaration,
#   adding magic variable `this`
# Arguments:
#   object name
#   method body
# Outputs:
#   processed method body
#######################################
function _preprocess_method_body() {
  local object_name
  local method_body

  object_name="${1}"; shift
  method_body="${1}"; shift

  echo -e "local this
  this=\"${object_name}\"

  ${method_body}"
}

#######################################
# Get body of object method
# Arguments:
#   object name
#   method name
# Outputs:
#   method body
#######################################
function _get_method() {
  local object_name
  local method_name
  local method_body
  local internal_object_methods_name

  object_name="${1}"; shift
  method_name="${1}"; shift
  internal_object_methods_name="$(_get_internal_methods_name "${object_name}")"

  method_body="$(_get_array_value "${internal_object_methods_name}" "${method_name}")"

  _preprocess_method_body "${object_name}" "${method_body}"
}

#######################################
# Get names of all declared object methods
# Arguments:
#   object name
# Outputs:
#   method names
#######################################
function _get_all_method_names() {
  local object_name
  local internal_methods_name

  object_name="${1}"; shift
  internal_methods_name="$(_get_internal_methods_name "${object_name}")"

  _get_array_keys "${internal_methods_name}"
}

#######################################
# Get object type
# Arguments:
#   object name
# Outputs:
#   object type (class/instance)
#######################################
function _get_type() {
  local object_name

  object_name="${1}"; shift

  _get_attribute "${object_name}" "${OBJECT_TYPE_ATTRIBUTE_NAME}"
}

#######################################
# Get parent class of an object
# Arguments:
#   object name
# Outputs:
#   object parent
#######################################
function _get_parent() {
  local object_name

  object_name="${1}"; shift

  _get_attribute "${object_name}" "${OBJECT_PARENT_ATTRIBUTE_NAME}"
}

#######################################
# Set object attribute
# Arguments:
#   object name
#   attribute name
#   attribute value
#######################################
function _set_attribute() {
  local object_name
  local attribute_name
  local attribute_value
  local internal_object_attributes_name

  object_name="${1}"; shift
  attribute_name="${1}"; shift
  attribute_value="${1}"; shift

  internal_object_attributes_name="$(_get_internal_attributes_name "${object_name}")"

  _set_array_value "${internal_object_attributes_name}" "${attribute_name}" "${attribute_value}"
}

#######################################
# Save and declare object method
# Arguments:
#   object name
#   method name
#   method body
#######################################
function _set_method() {
  local object_name
  local method_name
  local method_value
  local internal_object_methods_name

  object_name="${1}"; shift
  method_name="${1}"; shift
  method_value="${1}"; shift

  internal_object_methods_name="$(_get_internal_methods_name "${object_name}")"

  _set_array_value "${internal_object_methods_name}" "${method_name}" "${method_value}"
  _declare_method "${object_name}" "${method_name}"
}

#######################################
# Copy attributes from SRC object to DST object
# Arguments:
#   SRC object name
#   DST object name
#######################################
function _copy_attributes() {
  local src_object
  local dst_object

  src_object="${1}"; shift
  dst_object="${1}"; shift

  _copy_array \
    "$(_get_internal_attributes_name "${src_object}")" \
    "$(_get_internal_attributes_name "${dst_object}")"
}

#######################################
# Copy methods from SRC object to DST object
# Arguments:
#   SRC object name
#   DST object name
#######################################
function _copy_methods() {
  local src_object
  local dst_object

  src_object="${1}"; shift
  dst_object="${1}"; shift

  _copy_array \
    "$(_get_internal_methods_name "${src_object}")" \
    "$(_get_internal_methods_name "${dst_object}")"
}

#######################################
# Set a list of default object attributes to passed values
#   The attributes are: __name__, __type__, __parent__
# Arguments:
#   object name
#   object type (class/instance)
#   object parent. optional
#######################################
function _declare_default_attributes() {
  local object_name
  local object_type
  local object_parent

  object_name="${1}"; shift
  object_type="${1}"; shift
  object_parent="${1}"; shift

  _set_attribute "${object_name}" "${OBJECT_TYPE_ATTRIBUTE_NAME}" "${object_type}"
  _set_attribute "${object_name}" "${OBJECT_PARENT_ATTRIBUTE_NAME}" "${object_parent}"
  _set_attribute "${object_name}" "${OBJECT_NAME_ATTRIBUTE_NAME}" "${object_name}"
}

#######################################
# Set methods common for all objects
# Arguments:
#   object name
#######################################
function _declare_default_methods() {
  local object_name
  local internal_object_methods_name

  object_name="${1}"; shift

  internal_object_methods_name="$(_get_internal_methods_name "${object_name}")"

  declare -gx -A "${internal_object_methods_name}"
  eval "${internal_object_methods_name}[_]=:"
}

#######################################
# Destroy default object containers (attributes/methods)
# Arguments:
#   object name
#######################################
function _destroy_default_containers() {
  local object_name
  local internal_methods_name
  local internal_attributes_name

  object_name="${1}"; shift
  internal_methods_name="$(_get_internal_methods_name "${object_name}")"
  internal_attributes_name="$(_get_internal_attributes_name "${object_name}")"

  unset "${internal_methods_name}"
  unset "${internal_attributes_name}"
}

#######################################
# Declare a function that serves as an
#   entrypoint for an object
# Arguments:
#   object name
#######################################
function _declare_entrypoint() {
  local object_name

  object_name="${1}"; shift

  eval "
  ${object_name}() {
    _handle_input ${object_name} \"\${@}\"
  }
  "
}

#######################################
# Destroy an object entrypoint function
# Arguments:
#   object name
#######################################
function _destroy_entrypoint() {
  local object_name

  object_name="${1}"; shift

  unset -f "${object_name}" &>/dev/null
}

#######################################
# Declare a shell function, linked to object
# Arguments:
#   object name
#   method name
#######################################
function _declare_method() {
  local object_name
  local method_name
  local method_body
  local real_method_name

  object_name="${1}"; shift
  method_name="${1}"; shift

  real_method_name="$(_get_internal_method_name "${object_name}" "${method_name}")"
  method_body="$(_get_method "${object_name}" "${method_name}")"

  eval "${real_method_name}() {
  ${method_body}
  }"
}

#######################################
# Execute shell function associated with object method
# Arguments:
#   object name
#   method name
#   *method args
#######################################
function _call_method() {
  local object_name
  local method_name
  local escaped_parameters
  local real_method_name

  object_name="${1}"; shift
  method_name="${1}"; shift
  real_method_name="$(_get_internal_method_name "${object_name}" "${method_name}")"
  escaped_parameters="$(for i in "${@}"; do echo -n "\"$i\" "; done)"

  eval "${real_method_name} ${escaped_parameters}"
}

#######################################
# Execute magic init method
# Arguments:
#   object name
#   *method args
#######################################
function _call_init_method() {
  local object_name
  local method_owner

  object_name="${1}"; shift
  method_owner="$(_resolve_method "${object_name}" "${INIT_METHOD_NAME}")"

  _call_method "${method_owner}" "${INIT_METHOD_NAME}" "${@}"
}

#######################################
# Execute magic destroy method
# Arguments:
#   object name
#   *method args
#######################################
function _call_destroy_method() {
  local object_name
  local method_owner

  object_name="${1}"; shift
  method_owner="$(_resolve_method "${object_name}" "${DESTROY_METHOD_NAME}")"

  _call_method "${method_owner}" "${DESTROY_METHOD_NAME}" "${@}"
}

#######################################
# Unset a declared object method
# Arguments:
#   object name
#   method name
#######################################
function _destroy_method() {
  local object_name
  local method_name
  local internal_method_name
  local internal_methods_name

  object_name="${1}"; shift
  method_name="${1}"; shift
  internal_method_name="$(_get_internal_method_name "${object_name}" "${method_name}")"
  internal_methods_name="$(_get_internal_methods_name "${object_name}")"

  _unset_array_key "${internal_methods_name}" "${method_name}"
  unset -f "${internal_method_name}" &>/dev/null
}

#######################################
# Create a new object of type `instance`
#   copying all attributes and methods of `class`
# Arguments:
#   parent name
#   instance name
#######################################
function _declare_instance() {
  local parent_name
  local instance_name

  parent_name="${1}"; shift
  instance_name="${1}"; shift

  _copy_attributes "${parent_name}" "${instance_name}"
  _copy_methods "${parent_name}" "${instance_name}"

  for method_name in $(_get_array_keys "$(_get_internal_methods_name "${instance_name}")"); do
    _declare_method "${instance_name}" "${method_name}"
  done

  _declare_default_attributes "${instance_name}" "${INSTANCE_TYPE_NAME}" "${parent_name}"
  _declare_default_methods "${instance_name}"
  _declare_entrypoint "${instance_name}"
}

#######################################
# Destroy an object of type `instance`
#   along with all its declared methods and attributes
# Arguments:
#   instance name
#######################################
function _destroy_instance() {
  local object_name

  object_name="${1}"; shift

  for method in $(_get_all_method_names "${object_name}"); do
    _destroy_method "${object_name}" "${method}"
  done

  _destroy_entrypoint "${object_name}"
  _destroy_default_containers "${object_name}"
}

#######################################
# Return textual representation of a class
# Arguments:
#   object name
#######################################
function _get_class_representation() {
  local object_name

  object_name="${1}"; shift

  echo "<class '${object_name}'>"
}

#######################################
# Return textual representation of an instance
# Arguments:
#   object name
#######################################
function _get_instance_representation() {
  local object_name
  local object_parent

  object_name="${1}"; shift
  object_parent="$(_get_parent "${object_name}")"

  echo "<instance '${object_name}' of class '${object_parent}'>"
}

#######################################
# Find object KEY in closest parent or object itself.
#   KEY container is defined by passed container getter
# Arguments:
#   object name
#   container name getter
#   search key
# Outputs:
#   object name (if found)
#######################################
function _resolve() {
  local object_name
  local container_name_getter
  local search_key

  local object_parent
  local container_name

  object_name="${1}"; shift
  container_name_getter="${1}"; shift
  search_key="${1}"; shift

  object_parent="$(_get_parent "${object_name}")"
  container_name="$("${container_name_getter}" "${object_name}")"

  if _array_has_key "${container_name}" "${search_key}"; then
    echo "${object_name}"
  else
    if _value_is_empty "${object_parent}"; then
      return
    else
      _resolve "${object_parent}" "${container_name_getter}" "${search_key}"
    fi
  fi

}

#######################################
# Find object method in closest parent or
#   object itself.
# Arguments:
#   object name
#   method name
# Outputs:
#   object name (if found)
#######################################
function _resolve_method() {
  local object_name
  local method_name

  object_name="${1}"; shift
  method_name="${1}"; shift

  _resolve "${object_name}" "_get_internal_methods_name" "${method_name}"
}

#######################################
# Find object attribute in closest parent or
#   object itself.
# Arguments:
#   object name
#   attribute name
# Outputs:
#   object name (if found)
#######################################
function _resolve_attribute() {
  local object_name
  local attribute_name

  object_name="${1}"; shift
  attribute_name="${1}"; shift

  _resolve "${object_name}" "_get_internal_attributes_name" "${attribute_name}"
}