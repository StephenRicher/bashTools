#!/usr/bin/env bash

is_empty_file() {
    local path="${1}"

    [[ ! -s "${path}" ]]
}

is_empty_file "${@}"
