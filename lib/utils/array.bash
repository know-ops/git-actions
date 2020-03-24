#!/usr/bin/env bash

function arrayNewLine2Space() {  
  tr '\n' ' '
  return 
}

function arrayFilterRegexp() {
  local REGEXP="${1}"

  grep -E "${REGEXP}"
  return
}