#! /usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}/../constants.sh"

function _get_internal_object_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}"
}

function _get_internal_object_attributes_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}${ATTRIBUTES_SUFFIX}"
}

function _get_internal_object_methods_name() {
  echo "${LIBRARY_PREFIX}${OBJECT_PREFIX}${1}${METHODS_SUFFIX}"
}

function _get_object_attribute() {
  local object_name
  local attribute_name
  local internal_object_attributes_name

  object_name="${1}"; shift
  attribute_name="${1}"; shift
  internal_object_attributes_name="$(_get_internal_object_attributes_name "${object_name}")"
  eval "echo \"\${${internal_object_attributes_name}[${attribute_name}]}\""
}

function _get_object_type() {
  local object_name

  object_name="${1}"; shift

  _get_object_attribute "${object_name}" "${OBJECT_TYPE_ATTRIBUTE_NAME}"
}

function _get_object_parent() {
  local object_name

  object_name="${1}"; shift

  _get_object_attribute "${object_name}" "${OBJECT_PARENT_ATTRIBUTE_NAME}"
}

#######################################
# Set a list of default object attributes to passed values
#   The attributes are: __name__, __type__, __parent__
# Arguments:
#   object name. string
#   object type. string (class/instance)
#   object parent. string. optional
#######################################
function _declare_default_object_attributes() {
  local object_name
  local object_type
  local object_parent

  object_name="${1}"; shift
  object_type="${1}"; shift
  object_parent="${1}"; shift

  internal_object_attributes_name="$(_get_internal_object_attributes_name "${object_name}")"

  declare -gx -A "${internal_object_attributes_name}"

  eval "${internal_object_attributes_name}[${OBJECT_TYPE_ATTRIBUTE_NAME}]=${object_type}"
  eval "${internal_object_attributes_name}[${OBJECT_PARENT_ATTRIBUTE_NAME}]=${object_parent}"
  eval "${internal_object_attributes_name}[${OBJECT_NAME_ATTRIBUTE_NAME}]=${object_name}"
}

#######################################
# Set methods common for all objects
# Arguments:
#   object name. string
#######################################
function _declare_default_object_methods() {
  local object_name
  local internal_object_methods_name

  object_name="${1}"; shift

  internal_object_methods_name="$(_get_internal_object_methods_name "${object_name}")"

  declare -gx -A "${internal_object_methods_name}"
  eval "${internal_object_methods_name}[_]=:"
}

#######################################
# Declare a function that serves as an
#   entrypoint for an object
# Arguments:
#   object name. string
#######################################
function _declare_object_entrypoint() {
  local object_name

  object_name="${1}"; shift

  eval "
  ${object_name}() {
    _handle_object_input ${object_name} \"\${@}\"
  }
  "
}