#! /usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${SCRIPT_DIR}/../utils.sh"
source "${SCRIPT_DIR}/../constants.sh"
source "${SCRIPT_DIR}/errors.sh"

function _variable_is_empty() {
  ! [[ "${1}" ]]
}

function _variable_is_declared() {
  [[ "${1+x}" ]]
}

function _function_is_declared() {
  declare -F | cut -d" " -f3 | grep -q "^${1}$"
}

function _value_matches_regex() {
  echo "${1}" | grep -qE "${2}"
}

function _assert_object_not_declared() {
  if _function_is_declared "${1}"; then
    _throw_error "${ERRORS[object_declared]}" "${1}"
  fi
}

function _assert_object_name_valid() {
  if ! _value_matches_regex "${1}" "${VALID_OBJECT_NAME_REGEX}"; then
    _throw_error "${ERRORS[invalid_object_name]}" "${1}"
  fi
}