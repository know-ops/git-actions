#!/usr/bin/env bash

. $(dirname $0)/../lib/git/show.bash
. $(dirname $0)/../lib/utils/array.bash

main() {
  local -i is_mode_created=0
  local -i is_mode_modified=0
  local -i is_mode_deleted=0
  local filter_regexp=""

  if [ "${INPUT_GIT_CREATED}" = "true" ]; then
    is_mode_created=1
  fi

  if [ "${INPUT_GIT_MODIFIED}" = "true" ]; then
    is_mode_modified=1
  fi

  if [ "${INPUT_GIT_DELETED}" = "true" ]; then
    is_mode_deleted=1
  fi

  if [ ! -z "${INPUT_GIT_FILTER}" ]; then
    filter_regexp="${INPUT_GIT_FILTER}"
  fi

  echo "::debug file=files_changed.sh,line10::handle options"
  while (( $# > 0 )); do
    case "$1" in
      -c|--created) is_mode_created=1; shift ;;
      -m|--modified) is_mode_modified=1; shift ;;
      -d|--deleted) is_mode_deleted=1; shift ;;
      --) shift; break ;;
      *) break ;;
    esac
  done

  if [[ "" = "${filter_regexp}" ]]; then
    FILES="$(git_show_name_only | arrayNewLine2Space)"
  else
    FILES="$(git_show_name_only | arrayFilterRegexp "${filter_regexp}" | arrayNewLine2Space)"
  fi

  if [[ ! -z "${FILES}" ]]; then
    echo "::set-output name=files::${FILES}"
  fi

  if (( $is_mode_created )); then
    if [[ "" = "${filter_regexp}" ]]; then
      FILES="$(git_show_created_only | arrayNewLine2Space)"
    else
      FILES="$(git_show_created_only | arrayFilterRegexp "${filter_regexp}" | arrayNewLine2Space)"
    fi

    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=created_files::${FILES}"
    fi
  fi

  if (( ${is_mode_modified} )); then
    if [[ "" = "${filter_regexp}" ]]; then
      FILES="$(git_show_modified_only | arrayNewLine2Space)"
    else
      FILES="$(git_show_modified_only | arrayFilterRegexp "${filter_regexp}" | arrayNewLine2Space)"
    fi

    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=modified_files::${FILES}"
    fi
  fi

  if (( ${is_mode_deleted} )); then
    if [[ "" = "${filter_regexp}" ]]; then
      FILES="$(git_show_deleted_only | arrayNewLine2Space)"
    else
      FILES="$(git_show_deleted_only | arrayFilterRegexp "${filter_regexp}" | arrayNewLine2Space)"
    fi

    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=deleted_files::${FILES}"
    fi
  fi

}

main ${@:1}
