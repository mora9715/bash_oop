#!/usr/bin/env bash

LIB_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Core library with functionality related to class management
source "${LIB_DIR}/core/main.sh"

# Base classes such as Object
source "${LIB_DIR}/classes/object.sh"
