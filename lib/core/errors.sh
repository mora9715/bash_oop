#! /bin/env bash
# shellcheck disable=SC2016,SC2034

declare -A ERRORS

ERRORS[invalid_object_name]='InvalidObjectName: name \"${1}\" is not valid for an object'
ERRORS[invalid_object_type]='InvalidObjectType: operation is not supported by an object of type \"${1}\"'
ERRORS[invalid_attribute_name]='InvalidAttributeName: name \"${1}\" is not valid for an attribute'
ERRORS[invalid_method_name]='InvalidMethodName: name \"${1}\" is not valid for a method'
ERRORS[attribute_error]='AttributeError: object \"${1}\" has no attribute \"${2}\"'
ERRORS[method_error]='MethodError: object \"${1}\" has no method \"${2}\"'
ERRORS[object_declared]='ObjectDeclared: an object with name \"${1}\" is already declared'
ERRORS[object_not_declared]='ObjectNotDeclared: an object with name \"${1}\" is not declared'
ERRORS[syntax_error]='SyntaxError: invalid syntax'
ERRORS[protected_attribute]='ProtectedAttributeError: cannot access/modify attribute \"${1} : ${2}\" as it is protected'
ERRORS[protected_method]='ProtectedMethodError: cannot access method \"${1} . ${2}\" as it is protected'