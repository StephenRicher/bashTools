#!/usr/bin/env bash

# Exit 0 if ANY arguments are valid files.
any_files() {
    local files=( "${@}" )

    all_empty "${files[@]}" && fail "Error: No arguments provided."

    local file
    for file in "${files[@]}"; do
        if [[ -f "${file}" ]]; then
            >&2 echo ""${file}" already exists."
            ec=0
        fi
    done

    exit "${ec-1}"
}


fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


any_files "${@}"


