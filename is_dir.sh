#!/usr/bin/env bash

is_dir() {
    local dir="${1}"

    [[ -d "${dir}" ]]
}

is_dir "${@}"
