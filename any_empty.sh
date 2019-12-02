#!/usr/bin/env bash

# Exit 0 if ANY provided arguments are empty.
any_empty() {

    while getopts 'n:' flag; do
        case "${flag}" in
            n) nargs="${OPTARG}" ;;
            *) usage
               exit 1;;
        esac
    done
    shift "$((OPTIND-1))"

    [[ -z "${nargs}" ]] \
        && fail "Error: Please provided number of expected arguments in -n."

    [[ "${#}" -gt "${nargs}" ]] \
        && fail "Error:  arguments ("${#}") than set to test (-n "${nargs}")."

    [[ "${#}" -ne "${nargs}" ]] && ec=0

    for var in "${@}"; do
        if [[ -z "${var}" ]]; then
            ec=0
        fi
    done

    exit "${ec-1}"

}

fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


usage() {
    >&2 echo usage...
}


any_empty "${@}"
