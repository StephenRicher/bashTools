#!/usr/bin/env bash


main() {
    local file
    local data_dir="."
    local qc_dir="."
    local threads=1

    while getopts 'i:d:q:j:' flag; do
        case "${flag}" in
            i) file="${OPTARG%/}" ;;
            d) data_dir="${OPTARG%/}" ;;
            q) qc_dir="${OPTARG%/}" ;;
            j) threads="${OPTARG}" ;;
            *) usage ;;
        esac
    done
    shift "$((OPTIND-1))"

    any_empty -n 1 "${file}" && fail "Error: Missing mandatory arguments."

    all_files "${file}" || fail

    all_dirs "${data_dir}" "${qc_dir}" || fail

    local cutadapt_params="${@}"

    # Calculate spare threads available for within each cutadapt.
    local ntasks=$(( $(cat "${file}" | wc -l) / 2 ))
    local spare_threads=$((threads / ntasks))
    if [[ "${spare_threads}" == 0 ]]; then
        spare_threads=1
    fi

    export -f run_paired_cutadapt
    parallel -j "${threads}" --colsep '\t' \
        run_paired_cutadapt {1} {2} \
            "${data_dir}" "${qc_dir}" "${spare_threads}" "${cutadapt_params}" \
        :::: <(deinterleave "${file}")
}

run_paired_cutadapt() {
    local forward="${1}"
    local reverse="${2}"
    local data_dir="${3}"
    local qc_dir="${4}"
    local threads="${5}"
    shift 5
    # Set to null if "${@}" is empty string
    local cutadapt_params=${@:+"${@}"}

    local forward_out="$(modify_path -d "${data_dir}" -a '-trim' "${forward}")"
    local reverse_out="$(modify_path -d "${data_dir}" -a '-trim' "${reverse}")"

    local sample=$(get_sample "${forward}") || fail

    cutadapt --output "${forward_out}" \
             --paired-output "${reverse_out}" \
             -j "${threads}" \
             ${cutadapt_params} \
             "${forward}" "${reverse}" \
        > "${qc_dir}"/"${sample}".cutadapt.txt

    printf "%s\n%s\n" "${forward_out}" "${reverse_out}"

}

deinterleave() {
    local file="${1}"

    paste -s -d '\t\n' "${file}"
}


fail() {
    all_empty "${@}" || >&2 echo "${1}"
    usage
    exit "${2-1}"
}


usage() {
    >&2 echo usage...
}


main "${@}"
