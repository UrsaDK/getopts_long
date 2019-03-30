PATH="$(git rev-parse --show-toplevel)/bin:${PATH}"
FEATURE="$(basename "${BATS_TEST_FILENAME}" '.bats' | tr '_' ' ')"

debug() {
    printf '\nEXPECTED:\n––––––––\n%s\n' "${1}" >&3
    printf '\nACTUAL:\n––––––––\n%s\n\n' "${2}" >&3
}

expect() {
  if ! test "${@}"; then
    case ${1} in
      -[[:alpha:]])
        debug "[[ ${1} ACTUAL ]]" "${!#}"
        ;;
      *)
        debug "${!#}" "${1}"
        ;;
    esac
    return 1
  fi
}

compare() {
    : ${1?Missing required parameter -- getopts arguments}
    : ${2?Missing required parameter -- getopts_long arguments}

    run getopts-${BATS_TEST_DESCRIPTION##* } ${1}
    expected_output="${output}"
    expected_lines=( "${lines[@]}" )
    expected_status=${status}

    run getopts_long-${BATS_TEST_DESCRIPTION##* } ${2}
    actual_output="${output}"
    actual_lines=( "${lines[@]}" )
    actual_status=${status}

    if [[ -n "${3+SET}" ]]; then
        expected_output="$(echo "${expected_output}" | sed -E "${3}")"
        actual_output="$(echo "${actual_output}" | sed -E "${3}")"
    fi

    expect "${expected_output}" == "${actual_output}"
    expect "${expected_status}" == "${actual_status}"
}
