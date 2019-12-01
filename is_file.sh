#!/usr/bin/env bash

is_file() {
    local file="${1}"

    [[ -f "${file}" ]]
}

is_file "${@}"
