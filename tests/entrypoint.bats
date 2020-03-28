#!/usr/bin/env ../lib/tests/bats/bin/bats

load ../lib/tests/bats-support/load
load ../lib/tests/bats-assert/load
load ../lib/tests/helpers

@test "entrypoint > should error as invalid action" {
  INPUT_GIT_ACTION="non-existent"

  run ./entrypoint.sh "${INPUT_GIT_ACTION}"

  assert_equal $status 63
  assert_output --partial "::${INPUT_GIT_ACTION} is not a valid Git Action!"
}

@test "entrypoint > files only" {
  local INPUT_GIT_ACTION="files_changed"

  run ./entrypoint.sh "${INPUT_GIT_ACTION}"

  assert_success
  assert_output --partial "::set-output name=files::"
}
