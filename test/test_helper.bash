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
${2}

RECEIVED (eg: getopts_long)
––––––––––––––---––––––––––
${1}

END_OF_MESSAGE
}

expect() {
  if ! test "${@}"; then
    case ${1} in
      -[[:alpha:]])
        debug "$(help test | grep -- "${1}")" "${!#}"
        ;;
      *)
        debug "${1}" "${!#}"
        ;;
    esac
    return 1
  fi
}

compare() {
    : "${1?Missing required parameter -- getopts arguments}"
    : "${2?Missing required parameter -- getopts_long arguments}"

    run "getopts-${BATS_TEST_DESCRIPTION##* }" ${1}
    bash_getopts_output="${output}"
    bash_getopts_lines=( "${lines[@]}" )
    bash_getopts_status=${status}
    export bash_getopts_output bash_getopts_lines bash_getopts_status

    run "getopts_long-${BATS_TEST_DESCRIPTION##* }" ${2}
    getopts_long_output="${output}"
    getopts_long_lines=( "${lines[@]}" )
    getopts_long_status=${status}
    export getopts_long_output getopts_long_lines getopts_long_status

    if [[ -n "${3+SET}" ]]; then
        bash_getopts_output="$(echo "${bash_getopts_output}" | sed -E "${3}")"
        getopts_long_output="$(echo "${getopts_long_output}" | sed -E "${3}")"
    fi

    expect "${getopts_long_output}" == "${bash_getopts_output}"
    expect "${getopts_long_status}" == "${bash_getopts_status}"
}
