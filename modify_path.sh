#!/usr/bin/env bash

# Append string to file path before extension and modify directory.
modify_path() {

    while getopts 'd:a:' flag; do
        case "${flag}" in
            d) local dir="${OPTARG%/}" ;;
            a) local append="${OPTARG}" ;;
            *) usage ;;
        esac
    done
    shift "$((OPTIND-1))"

    if [[ "${#}" -ne 1 ]]; then
        fail "1 positional argument expected, received "${#}"."
    else
        local path="${1}"
    fi

    dir="${dir-$(dirname "${path}")}"/

    if [[ "${path}" == *"."* ]]; then
        local extension=."${path#*.}"
    else
         >&2 echo "No extension detected - appending to end of path."
    fi

    local filename="${path##*/}"
    local filename_rmext="${filename%%.*}"

    echo "${dir}""${filename_rmext}""${append}""${extension}"

}

fail() {
    local red='\033[0;31m'
    local no_colour='\033[0m'

    tput setaf 1
    >&2 echo "Error in "${0}": "${FUNCNAME[1]}"."
    all_empty "${@}" || >&2 echo "${1}"
    tput sgr0
    usage
    exit "${2-1}"
}

usage() {
    >&2 echo usage...
}

modify_path "${@}"
