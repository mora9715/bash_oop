#! /usr/bin/env bash

import_oop_library() {
  source "${BATS_TEST_DIRNAME}/../lib/main.sh"
}

setup_class() {
  source "${BATS_TEST_DIRNAME}/../lib/main.sh"
  class "${1}"
}

repr_class() {
  setup_class "${1}"
  "${1}"
}