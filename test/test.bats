#! /usr/bin/env bats

load test_cases/main.bash

diag() {
    echo "$@" >&3
}

setup () {
  load test_helper/bats-assert/load
}

@test "Test class names validation" {
  # Unhappy flow
  for name in 'Not-Valid' '!notValid' 'not,<valid'; do
    run setup_class "${name}"
    assert_line --partial InvalidObjectName
    assert_failure
  done

  # Happy flow
  for name in 'IsValid' 'is_valid' '__is_valid'; do
    run setup_class "${name}"
    assert_success
  done
}

@test "Test class representation" {
  run repr_class "ClassName"

  assert_success
  assert_line --partial "ClassName"
}