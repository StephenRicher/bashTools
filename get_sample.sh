#!/usr/bin/env bash

# Extract sample-replicate name in format '^[^-]*(-[1-9]+)[-.]'
# e.g. Input: path/to/file/sample_group-1-trim.fastq.gz
#      Output: sample_group-1
#      Note: last deliminter (- or .) is ignored in output.

get_sample () {
    local path="${1}"

    all_empty "${path}" && fail "No arguments provided."

    sample=$(echo "${path##*/}" | grep -o -P '^[^-]*(-[1-9]+)[-.]')

    all_empty "${sample}" \
        && fail "No valid sample name detected in "${path}"" \
        || report "${sample}" "${path}"
}


report() {
    local sample="${1%?}"
    local path="${2}"

    >&2 echo "Sample name "${sample}" extracted from "${path}"."
    echo "${sample}"
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


get_sample "${@}"
