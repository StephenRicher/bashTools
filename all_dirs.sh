#!/usr/bin/env bash

# Exit 0 if ALL arguments are valid directories.
all_dirs() {
    local dirs=( "${@}" )

    all_empty "${dirs[@]}" && fail "Error: No arguments provided."

    for dir in "${dirs[@]}"; do
        if [[ ! -d "${dir}" ]]; then
            >&2 echo "Error: "${dir}" is not a directory."
            ec=1
        fi
    done

    exit "${ec-0}"
}


fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


all_dirs "${@}"
