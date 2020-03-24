#!/usr/bin/env bash

. $(dirname $0)/../lib/git/show.bash

function replaceNewLine() {
  echo -n "${1}" | tr '\n' ' '
  return 
}

main() {
  local -i is_mode_created=0
  local -i is_mode_modified=0
  local -i is_mode_deleted=0

  if [ "${INPUT_GIT_CREATED}" = "true" ]; then
    is_mode_created=1
  fi

  if [ "${INPUT_GIT_MODIFIED}" = "true" ]; then
    is_mode_modified=1
  fi

  if [ "${INPUT_GIT_DELETED}" = "true" ]; then
    is_mode_deleted=1
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

  FILES="$(replaceNewLine "$(git_show_name_only)")"
  if [[ ! -z "${FILES}" ]]; then
    echo "::set-output name=files::$(echo -n "${FILES}" | tr ' ' ',')"
  fi

  if (( $is_mode_created )); then
    FILES="$(replaceNewLine "$(git_show_created_only)")"
    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=created_files::$(echo -n "${FILES}" | tr ' ' ',')"
    fi
  fi

  if (( ${is_mode_modified} )); then
    FILES="$(replaceNewLine "$(git_show_modified_only)")"
    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=modified_files::$(echo -n "${FILES}" | tr ' ' ',')"
    fi
  fi

  if (( ${is_mode_deleted} )); then
    FILES="$(replaceNewLine "$(git_show_deleted_only)")"
    if [[ ! -z "${FILES}" ]]; then
      echo "::set-output name=deleted_files::$(echo -n "${FILES}" | tr ' ' ',')"
    fi
  fi

}

main ${@:1}
