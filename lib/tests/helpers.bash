#!/usr/bin/env bash

create_test_repo() {
  DIRNAME="${1:-}"
  TMPDIR="${2:-}"

  if [[ -z "${TMPDIR}" && -z "${DIRNAME}" ]]; then
    REPOPATH="$(mktemp --directory --tmpdir)"
  elif [[ -z "${DIRNAME}" ]]; then
    REPOPATH="$(mktemp --directory)"
  else
    REPOPATH="$(mktemp --directory)/${DIRNAME}"
  fi

  mkdir -p ${REPOPATH}
  git init ${REPOPATH} 2>&1 | sed -e 's/^/# /g' >&3

  echo "${REPOPATH}"
}

create_test_file() {
  local FILENAME="${1:-}"

  if [[ -z "${FILENAME}" ]]; then
    FILENAME="file.test"
  fi

  touch ${FILENAME}

  ls ${FILENAME}
}
