#!/usr/bin/env bash
#
# Module with utilities directly not related
# to core class library, but consumed by the latter


UTILS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "${UTILS_DIR}/error.sh"
source "${UTILS_DIR}/array.sh"
source "${UTILS_DIR}/misc.sh"