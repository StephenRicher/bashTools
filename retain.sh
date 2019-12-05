#!/usr/bin/env bash

# Return 0 if arg 1 is set to 'true'
retain() {
    local remove="${1}"
    local ec

    if [[ "${remove}" != "false" ]]; then
        >&2 echo "Existing files will not be overwritten."
        ec=0
    else
        >&2 echo "Existing files will be overwritten."
        ec=1
    fi

    return "${ec}"
}


fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


retain "${@}"
