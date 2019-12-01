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
        >&2 echo "Error: 1 positional argument expected, received "${#}"."
        usage
        exit 1
    else
        local path="${1}"
    fi

    dir="${dir-"${path%/*}"}"/

    if [[ "${path}" == *"."* ]]; then
        local extension=."${path#*.}"
    else
         >&2 echo "No extension detected - appending to end of path."
    fi

    local filename="${path##*/}"
    local filename_rmext="${filename%%.*}"

    echo "${dir}""${filename_rmext}""${append}""${extension}"

}

usage() {
    >&2 echo usage...
}

modify_path "${@}"
