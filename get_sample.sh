#!/usr/bin/env bash

# Extract sample/replicate name in format '^[^-]*(-[1-9]+)[-.]'
# e.g. Input: path/to/file/sample_group-1-trim.fastq.gz
#      Output: sample_group-1
#      Note: last deliminter (- or .) is ignored in output.
get_sample () {
    local path="${1}"

    all_empty "${path}" \
        && fail "Error: No argument provided to get_sample."

    sample=$(echo "${path##*/}" | grep -o -P '^[^-]*(-[1-9]+)[-.]')

    all_empty "${sample}" \
        && fail "Error: No valid sample name detected in "${path}"" \
        || echo "${sample%?}"
}

fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}

get_sample "${@}"
