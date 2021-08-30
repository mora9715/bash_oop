#! /usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}/helpers.sh"
source "${SCRIPT_DIR}/constructors.sh"

#######################################
# Route operation to appropriate operation handler
# Operations:
#   :    - attribute-related operation
#   .    - method-related operation
#   " "  - representation operation
#   else - instance construction operation
# Arguments:
#   object name. string
#   ** kwargs
#######################################
function _handle_object_input() {
  local object_name

  object_name="${1}"; shift

  case ${1} in
    "") shift; _handle_object_representation "${object_name}";;
    ":") shift; _handle_object_attribute "${object_name}" "${@}";;
    ".") shift; _handle_object_method "${object_name}" "${@}";;
    *) _construct_instance "${object_name}" "${@}";;
  esac
}

#######################################
# Return object representation
# Arguments:
#   object name. string
# Outputs:
#   writes representation to STDOUT
#######################################
function _handle_object_representation() {
  local object_name
  local object_type

  object_name="${1}"; shift
  object_type="$(_get_object_type "${object_name}")"

  case "${object_type}" in
    "${CLASS_TYPE_NAME}") _handle_class_representation "${object_name}";;
    "${INSTANCE_TYPE_NAME}") _handle_instance_representation "${object_name}";;
  esac
}

function _handle_class_representation() {
  local object_name

  object_name="${1}"; shift

  echo "<class '${object_name}'>"
}

function _handle_instance_representation() {
  local object_name
  local object_parent

  object_name="${1}"; shift
  object_parent="$(_get_object_parent "${object_name}")"

  echo "<instance '${object_name}' of class '${object_parent}'>"
}