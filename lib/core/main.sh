#! /usr/bin/env bash

CORE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${CORE_DIR}/helpers.sh"
source "${CORE_DIR}/handlers.sh"
source "${CORE_DIR}/errors.sh"
source "${CORE_DIR}/validators.sh"
source "${CORE_DIR}/../utils/main.sh"
source "${CORE_DIR}/../constants.sh"

#######################################
# Validate user input and create a class object
# Arguments:
#   class name. string
#######################################
function class() {
  local object_name
  local parent_name

  object_name="${1}"; shift
  parent_name="${1}"; shift

  if _value_is_empty "${parent_name}"; then
    parent_name="${BASE_CLASS_NAME}"
  else
    _assert_object_declared "${parent_name}"
  fi

  _assert_object_name_valid "${object_name}"
  _assert_object_not_declared "${object_name}"

  _declare_default_attributes "${object_name}" "${CLASS_TYPE_NAME}" "${parent_name}"
  _declare_default_methods "${object_name}"
  _declare_entrypoint "${object_name}"
}
