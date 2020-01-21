#!/usr/bin/env bash

# Return 0 if arg 1 is set to 'true'
overwrite() {
    local remove="${1}"
    local ec

    all_empty "${remove}" && >&2 echo "Error: No arguments provided."

    if [[ "${remove}" = "TRUE" ]]; then
        >&2 echo "Existing files will be overwritten."
        ec=0
    else
        >&2 echo "Existing files will not be overwritten."
        ec=1
    fi

    return "${ec}"
}


overwrite "${@}"
