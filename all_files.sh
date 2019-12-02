#!/usr/bin/env bash

# Exit 0 if ALL arguments are valid files.
all_files() {
    local files=( "${@}" )

    all_empty "${files[@]}" && fail "Error: No arguments provided." 1

    for file in "${files[@]}"; do
        if [[ ! -f "${file}" ]]; then
            >&2 echo "Error: "${file}" is not a valid file."
            ec=1
        fi
    done

    exit "${ec-0}"
}


fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


all_files "${@}"

