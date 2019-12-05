#!/usr/bin/env bash

is_dir() {
    local dir="${1}"

    all_empty "${dir}" && fail "Error: No arguments provided."

    if [[ ! -d "${dir}" ]]; then
        >&2 echo ""${dir}" is not a directory."
        ec=1
    fi

    exit "${ec-0}"
}

fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}

is_dir "${@}"
