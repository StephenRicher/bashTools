#!/usr/bin/env bash

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="${@}"

smart_gzip() {
    local file="${1}"

    all_empty "${file}" && fail "No arguments provided."

    ( [[ "${file}" = *.gz ]] && gzip || cat ) \
    > "${file}"
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

>&2 echo -e "\n\
${0##*/}
    Script demonstrating bashTools functionality and scripting best practise."
}

smart_gzip "${@}"
