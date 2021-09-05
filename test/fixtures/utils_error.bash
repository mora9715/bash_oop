#! /usr/bin/env bash
# shellcheck disable=SC2034

function test_print_stacktrace() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"
  _print_stacktrace
}

function test_throw_error() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"
  _throw_error
}
