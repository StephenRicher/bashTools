#!/usr/bin/env bash

# Minimal readonly variables to be defined in every script.
# Readonly variables should be capitalised.
readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(readlink -m $(dirname $0))
readonly ARGS="${@}"

# Also can define other configuration variables as readonly here.
readonly PROJECT_NAME=RNA-Seq

# In general, commmand line arguments should be readonly and processed in a
# dedicated function as below. Arguments requiring default values should be
# initially set as NOT readonly (to allow them to be modified in getopts) and
# then set to readonly immediately after.
cmdline() {

    # Set defaults for opt args.
    QC_DIR=./
    DATA_DIR=./
    THREADS=6
    OUT=/dev/stdout # Write output to stdout as default.
    REMOVE=FALSE
    while getopts 'o:d:q:j:f' flag; do
        case "${flag}" in
            o) OUT="${OPTARG}" ;;
            d) DATA_DIR="${OPTARG}"/ ;; # Append / to all directories.
            q) QC_DIR="${OPTARG}"/ ;;
            j) THREADS="${OPTARG}" ;;
            f) readonly REMOVE="TRUE" ;;
            *) fail ;;
        esac
    done
    # Set opt args as readonly.
    readonly QC_DIR
    readonly DATA_DIR
    readonly THREADS
    readonly OUT
    readonly REMOVE
    shift "$((OPTIND-1))"

    # Positional arguments should also be readonly.
    readonly INPUT="${1}"

    # Check for missing mandatory arguments.
    any_empty -n 1 "${INPUT}" \
        && fail "Error: Missing mandatory arguments."

    # Check input files are valid files.
    all_files "${INPUT}" || fail

    # Check output directories exist.
    #all_dirs "${QC_DIR}" || fail

    # Check if output file already exists - ignore /dev/ files.
    # If it exists then check if is OK to overwrite (-f flag set) else fail.
    [[ "${OUT}" != /dev/stdout ]] \
        && any_files "${OUT}" \
        && (overwrite "${REMOVE}" || fail)
}

main() {
    # Process command line arguments - note no quotes around ARGS
    cmdline ${ARGS}

    # Extract sample name from file name, otherwise set default.
    local sample=$(get_sample "${INPUT}" || echo sample)

    # Set logfile after removing ALL file extensions.
    local log="${QC_DIR}"/$(basename "${INPUT%%.*}").log
    echo "Log file path: "${log}""

    # Use modify_path to append strings to file paths and modify directories.
    local intermediate=$(modify_path -a -filtered -d "${DATA_DIR}" "${INPUT}")
    echo -e "Original: "${INPUT}" \nModified "${intermediate}""

    # Use smart_gzip to conditionally gzip stdin and write to file.
    # If the OUT file names ends with .gz or .gzip then run gzip.
    cat "${INPUT}" | rev | smart_gzip "${OUT}"

}


usage() {

>&2 echo -e "\n\
Usage: ${0##*/}
    Script demonstrating bashTools functionality and scripting best practise."
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

main
