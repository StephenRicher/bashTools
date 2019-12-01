#!/usr/bin/env bash

get_sample () {
    local path="${1}"

    echo "${path##*/}" | grep -o -P '^[^-]*(-[1-9]+)' \
        || fail "Error: No valid sample name detected."
}

fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}

get_sample "${@}"
