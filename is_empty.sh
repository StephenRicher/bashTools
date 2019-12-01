#!/usr/bin/env bash

is_empty() {
    local var="${1}"

    [[ -z "${var}" ]]
}

is_empty "${@}"
