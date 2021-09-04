#!/usr/bin/env bash
#
# Utilities for exception throwing functionality


#######################################
# Throw a specific error with a stacktrace and exit
# Arguments:
#   Message to display. Optional
#   **Context for message to display. Optional
# Outputs
#   Error message and stacktrace to STDERR
#######################################
function _throw_error() {
  error_text="GenericError: something went wrong"

  [[ "${1}" ]] && error_text="${1}"; shift

  _print_stacktrace
  eval "echo -e \"${error_text}\"" >&2; exit 1
}

#######################################
# Print a stacktrace for a called function
# Outputs
#   Stacktrace to STDERR
#######################################
function _print_stacktrace() {
  local frame=0 LINE SUB FILE

  echo "Stack trace (most recent call last)" >&2

  while read -r LINE SUB FILE < <(caller "$frame"); do
    echo -e "  ${SUB} @ ${FILE}:${LINE}" >&2
    ((frame++))
  done
  echo
}