#!/usr/bin/env bash

# Exit 0 if all provided arguments are empty.
all_empty() {
    local vars="${@}"

    [[ -z "${vars[@]}" ]]
}

all_empty "${@}"
