#!/usr/bin/env bash

# Append string to file path before extension and modify directory.
modify_path() {

    while getopts 'd:' flag; do
        case "${flag}" in
            d) dir="${OPTARG%/}" ;;
            *) usage ;;
        esac
    done
    shift "$((OPTIND-1))"

    local path="${1}"
    if is_empty "${path}"; then
        usage
        exit 1
    fi

    local append="${2}"
    echo "${dir}"
    local dir="${dir-"${path%/*}"}"

    local extension="${path#*.}"
    local filename="${path##*/}"
    local filename_rmext="${filename%%.*}"

    echo "${dir}"/"${filename_rmext}""${append}"."${extension}"

}

usage() {
    >&2 echo usage...
}

modify_path "${@}"
