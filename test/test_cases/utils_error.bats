#! /usr/bin/env bats

load ../fixtures/utils_error

setup () {
  load ../test_helper/bats-assert/load
  load ../test_helper/bats-support/load
}

diag() {
    echo "$@" >&3
}

@test "utils/error: print stacktrace" {
  run test_print_stacktrace

  assert_success
  assert_line --partial "test_print_stacktrace @ "
}

@test "utils/error: throw error" {
  run test_throw_error

  assert_failure
  assert_line "GenericError: something went wrong"
}
