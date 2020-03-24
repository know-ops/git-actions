#!/usr/bin/env ../../../lib/tests/bats/bin/bats

load ../../../lib/tests/helpers
load ../../../lib/tests/bats-support/load
load ../../../lib/tests/bats-assert/load

setup() {
  ORIGINAL_DIR=$(pwd)
  cd "$(create_test_repo)"
}

teardown() {
  cd "${ORIGINAL_DIR}"
}

@test "lib > tests > helpers > should be a git repositiory" {
  run git status

  assert_success
}

@test "lib > tests > helpers > shouldn't have any commits" {
  run git log

  assert_failure
}

@test "lib > tests > helpers > should create file.test" {
  run create_test_file
  
  assert_output "file.test"
}
