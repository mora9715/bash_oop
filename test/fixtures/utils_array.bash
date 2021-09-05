#! /usr/bin/env bash
# shellcheck disable=SC2034

function test_array_has_key() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  array[key]=value

  _array_has_key array key
}

function test_get_array_keys() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  array[x]=1
  array[y]=2
  array[z]=3

  _get_array_keys array
}

function test_get_array_value() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  array[key]=value

  _get_array_value array key
}

function test_set_array_value() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  _set_array_value array key value
  _get_array_value array key
}

function test_unset_array_key() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  array[x]=1
  array[y]=2
  _unset_array_key array y
  _get_array_value array y
}

function test_copy_array() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  declare -A array

  array[x]=value1
  array[y]=value2

  _copy_array array new_array
  _get_array_value new_array x
  _get_array_value new_array y
}