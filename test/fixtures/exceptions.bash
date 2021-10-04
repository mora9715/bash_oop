#! /usr/bin/env bash
# shellcheck disable=SC2034

function test_exceptions_raise() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  Exception DummyException

  raise DummyException
}

function test_exceptions_raise_message() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  Exception DummyException

  raise DummyException "custom message"
}

function test_exceptions_raise_exit_code() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  Exception DummyException

  raise DummyException "custom message" 123
}