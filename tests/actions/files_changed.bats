#!/usr/bin/env ../../lib/tests/bats/bin/bats

load ../../lib/tests/bats-support/load
load ../../lib/tests/bats-assert/load
load ../../lib/tests/helpers
load ../../lib/git/commit

setup() {
  ORGINAL_DIR=$(pwd)

  cd $(create_test_repo)

  COMMIT_MSG="[BATS] initial commit"
  TEST_FILE="test.bats"

  create_test_file ${TEST_FILE}
  git_commit "${COMMIT_MSG}" | sed -e 's/^/# /g' >&3 2>&1
}

teardown() {
  cd ${ORGINAL_DIR}
}

@test "actions > files_changed > files only > should have a test file" {
  run ${ORGINAL_DIR}/actions/files_changed.sh

  assert_success
  assert_output --regexp ".*::set-output name=files::.*${TEST_FILE}.*"
  refute_output --partial "::set-output name=created_files::"
  refute_output --partial "::set-output name=modified_files::"
  refute_output --partial "::set-output name=deleted_files::"
}

@test "actions > files_changed > files, created_files > should have a test file" {
  run ${ORGINAL_DIR}/actions/files_changed.sh --created

  assert_success
  assert_output --regexp "::set-output name=files::.*${TEST_FILE}.*"
  assert_output --regexp "::set-output name=created_files::.*${TEST_FILE}.*"
  refute_output --partial "::set-output name=modified_files::"
  refute_output --partial "::set-output name=deleted_files::"
}

@test "actions > files_changed > files, modified_files > should have a test file" {
  echo "change #1" > ${TEST_FILE}
  git_commit "[BATS] Modified ${TEST_FILE}" | sed -e 's/^/# /g' >&3 2>&1

  run ${ORGINAL_DIR}/actions/files_changed.sh --modified

  assert_success
  assert_output --regexp "::set-output name=files::.*${TEST_FILE}.*"
  refute_output --partial "::set-output name=created_files::"
  assert_output --regexp "::set-output name=modified_files::.*${TEST_FILE}.*"
  refute_output --partial "::set-output name=deleted_files::"
}

@test "actions > files_changed > files, deleted_files > should have a test file" {
  rm ${TEST_FILE}
  git_commit "[BATS] Deleted ${TEST_FILE}" | sed -e 's/^/# /g' >&3 2>&1
  
  run ${ORGINAL_DIR}/actions/files_changed.sh --deleted

  assert_success
  assert_output --partial "::set-output name=files::"
  refute_output --partial "::set-output name=created_files::"
  refute_output --partial "::set-output name=modified_files::"
  assert_output --partial "::set-output name=deleted_files::"
}

@test "actions > files_changed > multiple files, should show all files created, or modified" {
  TEST_FILE2="test2.bats"

  echo "change #1" >${TEST_FILE}
  touch ${TEST_FILE2}

  git_commit "${COMMIT_MSG}; added ${TEST_FILE2}"

  run ${ORGINAL_DIR}/actions/files_changed.sh --created --modified

  assert_output --regexp ".*::set-output name=files::.*${TEST_FILE}.*"
  assert_output --regexp ".*::set-output name=files::.*${TEST_FILE2}.*"
  assert_output --regexp ".*::set-output name=modified_files::.*${TEST_FILE}.*"
  assert_output --regexp ".*::set-output name=created_files::.*${TEST_FILE2}.*"
}

@test "actions > files_changed > multiple files, filter to .*test.bats.*" {
  TEST_FILE2="test2.bats"

  echo "change #1" >${TEST_FILE}
  touch ${TEST_FILE2}

  git_commit "${COMMIT_MSG}; added ${TEST_FILE2}"

  export INPUT_GIT_FILTER=".*${TEST_FILE}.*"

  run ${ORGINAL_DIR}/actions/files_changed.sh --created --modified

  assert_output --regexp ".*::set-output name=files::.*${TEST_FILE}.*"
  refute_output --regexp ".*::set-output name=files::.*${TEST_FILE2}.*"
  assert_output --regexp ".*::set-output name=modified_files::.*${TEST_FILE}.*"
  refute_output --regexp ".*::set-output name=created_files::.*${TEST_FILE2}.*"
}
