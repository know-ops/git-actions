#!/usr/bin/env bash

git_commit() {
  git add .

  if [ -z "${KO_COMMIT_MSG}" ]; then
    KO_COMMIT_MSG="[CHORE] > "
  fi

  git commit -m "${KO_COMMIT_MSG}${1}"
}
