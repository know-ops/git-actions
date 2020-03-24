#!/usr/bin/env bash

. $(dirname ${BASH_SOURCE})/../utils/array.bash

git_show_name_only() {
  git show --pretty="" --name-only
}

git_show_name_status() {
  git show --pretty="" --name-status | arrayFilterRegexp "${1}" | awk '{ print $2 }'
}

git_show_created_only() {
  git_show_name_status "^A[ ]*"
}

git_show_modified_only() {
  git_show_name_status "^M[ ]*"
}

git_show_deleted_only() {
  git_show_name_status "^D[ ]*"
}
