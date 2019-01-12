PATH="$(git rev-parse --show-toplevel)/bin:${PATH}"
FEATURE="$(basename "${BATS_TEST_FILENAME}" '.bats' | tr '_' ' ')"

run_tests() {
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

    test "${expected_output}" == "${actual_output}" || ( show_output && false )
    test "${expected_status}" == "${actual_status}" || ( show_output && false )
}

show_output() {
    printf '\nEXPECTED:\n--------\n%s\n$?: %i\n' \
        "${expected_output}" ${expected_status} >&3

    printf '\nACTUAL:\n------\n%s\n$?: %i\n\n' \
        "${actual_output}" ${actual_status} >&3
}
