#! /usr/bin/env bash


function setup_class() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"
  class "${1}"
}

function repr_class() {
  setup_class "${1}"
  "${1}"
}

function test_attribute_setter() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass : attribute = value
}

function test_attribute_getter() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass : attribute = value

  TestClass : attribute
}

function test_method_setter() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . method << 'EOF'
  echo "Hello, World!"
EOF
}

function test_method_executor() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . method << 'EOF'
  echo "Hello, World!"
EOF

  TestClass . method
}

function test_method_executor_with_args() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . method << 'EOF'
  echo "Hello, ${1}!"
EOF

  TestClass . method World
}

function test_method_executor_with_multiline_args() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass

TestClass . method << 'EOF'
  echo -e "Hello,${1}!"
EOF
  TestClass . method '\nWorld'
}

function test_instance_creation() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass

  TestClass test_instance
  test_instance
}

function test_instance_creation_from_instance() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass

  TestClass test_instance
  test_instance test_instance2
}

function test_instance_deletion() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass : attribute = value1

  TestClass test_instance
  test_instance : attribute = value2

  destroy test_instance

  TestClass test_instance
  test_instance : attribute
}

function test_object_exists() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  class TestClass
}

function test_inheritance() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class Parent
  Parent : attribute = value

  class Child Parent

  Child : attribute
}

function test_init_method() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . __init__ << 'EOF'
  echo "Hello from init!"
EOF

  TestClass test_instance
}

function test_destroy_method() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . __destroy__ << 'EOF'
  echo "Hello from destroy!"
EOF

  TestClass test_instance

  destroy test_instance
}

function test_set_protected_attribute() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass : _protected = value
}

function test_get_protected_attribute() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . setAttribute << 'EOF'
  ${this} : _attribute = "${1}"
EOF

  TestClass . setAttribute value

  TestClass : _attribute
}

function test_get_protected_attribute_from_inside() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . setAttribute << 'EOF'
  ${this} : _attribute = "${1}"
EOF

TestClass . getAttribute << 'EOF'
  ${this} : _attribute
EOF

  TestClass . setAttribute value

  TestClass . getAttribute
}

function test_set_protected_method() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . _protected_method << 'EOF'
  echo 'protected!'
EOF
}

function test_execute_protected_method() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . _protected_method << 'EOF'
  echo 'protected!'
EOF

  TestClass . _protected_method
}

function test_execute_protected_method_from_inside() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
TestClass . _protected_method << 'EOF'
  echo 'protected!'
EOF

TestClass . unprotected_method << 'EOF'
  ${this} . _protected_method
EOF

  TestClass . unprotected_method
}

function test_method_not_found() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass

  TestClass . does_not_exist
}

function test_attribute_type() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass test_instance

  TestClass : __type__
  test_instance : __type__
}

function test_attribute_name() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass test_instance

  TestClass : __name__
  test_instance : __name__
}

function test_attribute_parent() {
  source "${BATS_TEST_DIRNAME}/../../lib/main.sh"

  class TestClass
  TestClass test_instance

  TestClass : __parent__
  test_instance : __parent__
}
