#!/usr/bin/env bash

function main() {
  INPUT_GIT_ACTION="${INPUT_GIT_ACTION:-}"
  echo "::debug file=entrypoint.sh,line=5::\${INPUT_GIT_ACTION}=${INPUT_GIT_ACTION}"

  if [[ -z "${INPUT_GIT_ACTION}" ]]; then
    echo "::debug file=entrypoint.sh,line=8::\${1}=${1}"
    export INPUT_GIT_ACTION="${1}"
  fi
  echo "::debug file=entrypoint.sh,line=10::\${INPUT_GIT_ACTION}=${INPUT_GIT_ACTION}"

  if [ -e "./actions/${INPUT_GIT_ACTION}.sh" ]; then
    echo "::debug file=entrypoint.sh,line=14::executing ${INPUT_GIT_ACTION}"
    ./actions/${INPUT_GIT_ACTION}.sh ${@:2}

    return $?
  
  fi

  echo "::error file=entrypoint.sh,line=21::${INPUT_GIT_ACTION} is not a valid Git Action!"
  return 63
}

main $@
