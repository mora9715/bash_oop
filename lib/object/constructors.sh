#! /usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}/validators.sh"
source "${SCRIPT_DIR}/helpers.sh"

#######################################
# Create a class object and set all
#   default methods/attributes
# Arguments:
#   class name. string
#######################################
function _construct_class() {
  local object_name

  object_name="${1}"; shift

  _declare_default_object_attributes "${object_name}" "${CLASS_TYPE_NAME}"
  _declare_default_object_methods "${object_name}"
  _declare_object_entrypoint "${object_name}"
}

#######################################
# Construct a class instance and set
#   default methods/attributes
# Arguments:
#   class name. string
#   instance name. string
#######################################
function _construct_instance() {
  :
}