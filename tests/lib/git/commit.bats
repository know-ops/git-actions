#!/usr/bin/env ../../../lib/tests/bats/bin/bats

load ../../../lib/tests/bats-support/load
load ../../../lib/tests/bats-assert/load
load ../../../lib/tests/helpers
load ../../../lib/git/commit

setup() {
  ORIGINAL_DIR=$(pwd)
  cd $(create_test_repo commit ./tests/)
}

teardown() {
  cd ${ORIGINAL_DIR}
}

@test "lib > git > commit > should have an untracked file, file.test" {
  create_test_file
  run git status --short
  assert_success
  assert_output "?? file.test"
}

@test "lib > git > commit > should create a commit" {
  create_test_file
  
  COMMIT_MSG="[BATS] commit containing file.test"
  
  run git_commit "${COMMIT_MSG}"
  
  assert_success
  assert_line --index 0 --partial "[CHORE] > ${COMMIT_MSG}"
  assert_output --partial "file.test"
}
