#!/usr/bin/env bash

main() {
    local outdir=$(pwd)
    local threads=1
    local cookie

    while getopts 'o:c:j:' flag; do
        case "${flag}" in
            o) outdir="${OPTARG}" ;;
            c) cookie="${OPTARG}" ;;
            j) threads="${OPTARG}" ;;
            *) usage
               exit 1;;
        esac
    done
    shift "$((OPTIND-1))"

    # Confirm positional arguments are valid files.
    ! all_files "${@}" && exit 1

    is_dir "${outdir}" || fail "Error: "${outdir}" is not a directory."

    # Print paths outside of parallel to preserve order.
    print_paths "${@}"

    export -f download_url
    parallel -j "${threads}" --colsep '\t' \
        download_url {1} {2} "${outdir}" "${cookie}" :::: <(cat "${@}")
}

download_url() {
    local filename="${1}"
    local url="${2}"
    local outdir="${3-$(pwd)}"
    local cookie="${4}"
    local outpath

    if all_empty "${filename}"; then
        >&2 echo "Skipping empty line."
        return 0
    fi

    if [ "${filename}" == "-" ]; then
        outpath=/dev/stdout
    else
        outpath="${outdir}"/"${filename}"
        any_files "${outpath}" && return 1
    fi

    >&2 echo "Writing file to "${outpath}""

    # Set to null if "${cookie}" is empty string
    cookie=${cookie:+"${cookie}"}

    curl -L -H "Cookie: "${cookie}"" "${url}"  > "${outpath}"
}

print_paths() {
    local files="${@}"

    while read -r filename url; do
        if all_empty "${filename}"; then
            continue
        fi
        if [ "${filename}" != "-" ]; then
            echo "${outdir}"/"${filename}"
        fi
    done < <(cat "${@}")
}

usage() {
    >&2 echo usage...
}

fail() {
    >&2 echo "${1}"
    exit "${2-1}"
}


main "${@}"
