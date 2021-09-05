#! /usr/bin/env bats

load ../fixtures/core

setup () {
  load ../test_helper/bats-assert/load
  load ../test_helper/bats-support/load
}

diag() {
    echo "$@" >&3
}

@test "core: class names validation" {
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

@test "core: class representation" {
  run repr_class "ClassName"

  assert_success
  assert_line --partial "ClassName"
}

@test "core: attribute setter" {
  run test_attribute_setter

  assert_success
  assert_output ""
}

@test "core: attribute getter" {
  run test_attribute_getter

  assert_success
  assert_output "value"
}

@test "core: method setter" {
  run test_method_setter

  assert_success
  assert_output ""
}

@test "core: method executor" {
  run test_method_executor

  assert_success
  assert_output "Hello, World!"
}

@test "core: method executor with args" {
  run test_method_executor_with_args

  assert_success
  assert_output "Hello, World!"
}

@test "core: method executor with multiline args" {
  run test_method_executor_with_multiline_args

  assert_success
  assert_output "Hello,
World!"
}

@test "core: instance creation" {
  run test_instance_creation

  assert_success
  assert_output "<instance 'test_instance' of class 'TestClass'>"
}

@test "core: instance creation from another instance" {
  run test_instance_creation_from_instance

  assert_failure
  assert_line --partial "InvalidObjectType"
}

@test "core: instance deletion" {
  run test_instance_deletion

  assert_success
  assert_output "value1"
}

@test "core: object already exists" {
  run test_object_exists

  assert_failure
  assert_line --partial "ObjectDeclared"
}

@test "core: inheritance" {
  run test_inheritance

  assert_success
  assert_output "value"
}

@test "core: special init method" {
  run test_init_method

  assert_success
  assert_output "Hello from init!"
}

@test "core: special destroy method" {
  run test_destroy_method

  assert_success
  assert_output "Hello from destroy!"
}

@test "core: set protected attribute" {
  run test_set_protected_attribute

  assert_failure
  assert_line --partial "ProtectedAttributeError"
}

@test "core: get protected attribute" {
  run test_get_protected_attribute

  assert_failure
  assert_line --partial "ProtectedAttributeError"
}

@test "core: get protected attribute from inside" {
  run test_get_protected_attribute_from_inside

  assert_success
  assert_output "value"
}

@test "core: set protected method" {
  run test_set_protected_method

  assert_success
  assert_output ""
}

@test "core: execute protected method" {
  run test_execute_protected_method

  assert_failure
  assert_line --partial "ProtectedMethodError"
}

@test "core: execute protected method from inside" {
  run test_execute_protected_method_from_inside

  assert_success
  assert_output "protected!"
}

@test "core: method not found" {
  run test_method_not_found

  assert_failure
  assert_line --partial "MethodError"
}

@test "core: special attribute __type__" {
  run test_attribute_type

  assert_success
  assert_output "class
instance"
}

@test "core: special attribute __name__" {
  run test_attribute_name

  assert_success
  assert_output "TestClass
test_instance"
}

@test "core: special attribute __parent__" {
  run test_attribute_parent

  assert_success
  assert_output "Object
TestClass"
}