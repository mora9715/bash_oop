#! /usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}/constructors.sh"
source "${SCRIPT_DIR}/handlers.sh"

#######################################
# Validate user input and create a class object
# Arguments:
#   class name. string
#######################################
function class() {
  local object_name

  object_name="${1}"; shift

  _assert_object_name_valid "${object_name}"
  _assert_object_not_declared "${object_name}"

  _construct_class "${object_name}"
}
