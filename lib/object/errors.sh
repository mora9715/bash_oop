#! /bin/env bash
# shellcheck disable=SC2016,SC2034

declare -A ERRORS

ERRORS[invalid_object_name]='InvalidObjectName: name \"${1}\" is not valid for an object'
ERRORS[object_declared]='ObjectDeclared: an object with name \"${1}\" is already declared'