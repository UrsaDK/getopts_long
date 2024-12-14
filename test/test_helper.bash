# shellcheck disable=SC2086
# shellcheck disable=SC2154

TOPDIR="$(cd "${BATS_TEST_DIRNAME}"/.. && pwd)"
# shellcheck disable=SC2034
FEATURE="$(basename "${BATS_TEST_FILENAME}" '.bats' | tr '_' ' ')"
PATH="${TOPDIR}/bin:${PATH}"

debug() {
cat >&3 <<END_OF_MESSAGE

EXPECTED (eg: bash getopts)
––––––––––––––---––––––––––
${1}

RECEIVED (eg: getopts_long)
––––––––––––––---––––––––––
${2}

END_OF_MESSAGE
}

expect() {
    if [[ "${2}" == "=~" ]]; then
        if [[ ! "${1}" =~ ${3} ]]; then
            debug "${!#}" "${1}"
            return 1
        fi
    elif ! test "$@"; then
        case "${1}" in
            -[[:alpha:]])
                debug "$(help test | grep -- "${1}")" "${!#}"
                ;;
            *)
                debug "${!#}" "${1}"
                ;;
        esac
        return 1
    fi
}

compare() {
    : "${1?Missing required parameter -- getopts arguments}"
    : "${2?Missing required parameter -- getopts_long arguments}"

    run "${GETOPTS_TEST_BIN:-getopts}-${BATS_TEST_DESCRIPTION##* }" ${1}
    bash_getopts_output="${output}"
    bash_getopts=( "${status}" "${lines[@]}" )
    export bash_getopts

    run "${GETOPTS_LONG_TEST_BIN:-getopts_long}-${BATS_TEST_DESCRIPTION##* }" ${2}
    getopts_long_output="${output}"
    getopts_long=( "${status}" "${lines[@]}" )
    export getopts_long

    if [[ -n "${3+SET}" ]]; then
        shift 2
        for arg in "$@"; do
            sed_args+=("-e" "$arg")
        done
        bash_getopts_output="$(echo "${bash_getopts_output}" | sed -E "${sed_args[@]}")"
        getopts_long_output="$(echo "${getopts_long_output}" | sed -E "${sed_args[@]}")"
    fi

    expect "${getopts_long_output}" == "${bash_getopts_output}"
    expect "Exit status: ${getopts_long[0]}" == "Exit status: ${bash_getopts[0]}"
}
