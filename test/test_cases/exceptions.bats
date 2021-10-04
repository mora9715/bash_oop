#! /usr/bin/env bats

load ../fixtures/exceptions

setup () {
  load ../test_helper/bats-assert/load
  load ../test_helper/bats-support/load
}

diag() {
    echo "$@" >&3
}

@test "exceptions: raise" {
  run test_exceptions_raise

  assert_failure
  assert_line --partial "DummyException: something went wrong"
}

@test "exceptions: raise with message" {
  run test_exceptions_raise_message

  assert_failure
  assert_line --partial "DummyException: custom message"
}

@test "exceptions: raise with exit code" {
  run test_exceptions_raise_exit_code

  assert_equal ${status} 123
  assert_line --partial "DummyException: custom message"
}