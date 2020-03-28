#!/usr/bin/env ../../../lib/tests/bats/bin/bats

load ../../../lib/tests/helpers
load ../../../lib/tests/bats-support/load
load ../../../lib/tests/bats-assert/load
load ../../../lib/git/commit
load ../../../lib/git/show

setup() {
  ORIGINAL_DIR=$(pwd)
  cd $(create_test_repo)
  
  TEST_FILE="test.bats"
  COMMIT_MSG="[BATS] show file changes; added ${TEST_FILE}"

  create_test_file ${TEST_FILE}
  git_commit "${COMMIT_MSG}" | sed -e 's/^/# /g' >&3 2>&1
}

teardown() {
  cd ${ORIGINAL_DIR}
}

@test "lib > git > show > should only show 'test.bats'" {
  run git_show_name_only

  assert_output --partial "${TEST_FILE}"
}

@test "lib > git > show > new file, should only show 'test.bats'" {
  run git_show_created_only

  assert_output --partial "${TEST_FILE}"
}

@test "lib > git > show > new file, shouldn't only show 'test.bats' as modified" {
  run git_show_modified_only

  refute_output --partial "${TEST_FILE}"
}

@test "lib > git > show > new file, shouldn't only show 'test.bats' as deleted" {
  run git_show_deleted_only

  refute_output --partial "${TEST_FILE}"
}

@test "lib > git > show > modified file, should only show 'test.bats'" {
  echo "change #1" >${TEST_FILE}
  git_commit "${COMMIT_MSG} #2"

  run git_show_modified_only

  assert_output --partial "${TEST_FILE}"
}

@test "lib > git > show > modified file, shouldn't show 'test.bats' as created" {
  echo "change #1" >${TEST_FILE}
  git_commit "${COMMIT_MSG} #2"

  run git_show_created_only

  refute_output --partial "${TEST_FILE}"
}

@test "lib > git > show > modified file, shouldn't show 'test.bats' as deleted" {
  echo "change #1" >${TEST_FILE}
  git_commit "${COMMIT_MSG} #2"

  run git_show_deleted_only

  refute_output --partial "${TEST_FILE}"
}

@test "lib > git > show > deleted file, should only show 'test.bats'" {
  rm ${TEST_FILE}
  git_commit "${COMMIT_MSG} #3"

  run git_show_deleted_only

  assert_output --partial "${TEST_FILE}"
}

@test "lib > git > show > deleted file, shouldn't show 'test.bats' as created" {
  rm ${TEST_FILE}
  git_commit "${COMMIT_MSG} #3"

  run git_show_created_only

  refute_output --partial "${TEST_FILE}"
}

@test "lib > git > show > deleted file, shouldn't show 'test.bats' as modified" {
  rm ${TEST_FILE}
  git_commit "${COMMIT_MSG} #3"

  run git_show_modified_only

  refute_output --partial "${TEST_FILE}"
}
