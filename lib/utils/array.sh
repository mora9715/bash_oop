#!/usr/bin/env bash
#
# Set of functions to ease operations on
#   bash associated arrays.

#######################################
# Check if an array has a key
# Arguments:
#   array name
#   array key
# Returns:
#   0 - array has key
#   1 - array does not have key
#######################################
function _array_has_key() {
  [[ -v "${1}[${2}]" ]]
}

#######################################
# Get all array keys
# Arguments:
#   array name
# Outputs:
#   array keys
#######################################
function _get_array_keys() {
  local array_name

  array_name="${1}"; shift

  eval "echo \"\${!${array_name}[@]}\""
}

#######################################
# Get an array value by key
# Arguments:
#   array name
#   array key
# Outputs:
#   requested array value
#######################################
function _get_array_value() {
  local array_name
  local key_name

  array_name="${1}"; shift
  key_name="${1}"; shift

  eval "echo \"\${${array_name}[${key_name}]}\""
}

#######################################
# Set an array value by key
# Arguments:
#   array name
#   array key
#   array value
#######################################
function _set_array_value() {
  local array_name
  local key_name
  local value

  array_name="${1}"; shift
  key_name="${1}"; shift
  value="${1}"; shift

  declare -gx -A "${array_name}"
  eval "${array_name}[${key_name}]='${value}'"
}

#######################################
# Unset an array key
# Arguments:
#   array name
#   array key
#######################################
function _unset_array_key() {
  local array_name
  local array_key

  array_name="${1}"; shift
  array_key="${1}"; shift

  unset "${array_name}[${array_key}]"
}

#######################################
# Create a copy of an array
# Arguments:
#   source array name
#   destination array key
#######################################
function _copy_array() {
  local src_array_name
  local dst_array_name

  src_array_name="${1}"; shift
  dst_array_name="${1}"; shift

  declare -gx -A "${dst_array_name}"

  for i in $(_get_array_keys "${src_array_name}"); do
    _set_array_value "${dst_array_name}" "${i}" "$(_get_array_value "${src_array_name}" "${i}")"
  done
}
