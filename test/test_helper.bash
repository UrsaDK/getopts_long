PATH="$(git rev-parse --show-toplevel)/bin:${PATH}"
FEATURE="$(basename "${BATS_TEST_FILENAME}" '.bats' | tr '_' ' ')"

show_output() {
    printf '\nEXPECTED:\n--------\n%s\n$?: %i\n' \
        "${expected_output}" ${expected_status} >&3

    printf '\nACTUAL:\n------\n%s\n$?: %i\n\n' \
        "${actual_output}" ${actual_status} >&3
}
