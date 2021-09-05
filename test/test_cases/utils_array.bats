#! /usr/bin/env bats

load ../fixtures/utils_array

setup () {
  load ../test_helper/bats-assert/load
  load ../test_helper/bats-support/load
}

diag() {
    echo "$@" >&3
}

@test "utils/array: array has key" {
  run test_array_has_key

  assert_success
}

@test "utils/array: get all array keys" {
  run test_get_array_keys

  assert_success
  assert_line --partial "x"
  assert_line --partial "y"
  assert_line --partial "z"
}

@test "utils/array: get array value" {
  run test_get_array_value

  assert_success
  assert_line "value"
}

@test "utils/array: set array value" {
  run test_set_array_value

  assert_success
  assert_line "value"
}

@test "utils/array: unset array value" {
  run test_unset_array_key

  assert_success
  assert_output ""
}

@test "utils/array: copy array" {
  run test_copy_array

  assert_success
  assert_line value1
  assert_line value2
}

