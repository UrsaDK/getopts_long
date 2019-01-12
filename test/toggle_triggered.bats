#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: short option, verbose" {
    run getopts-${BATS_TEST_DESCRIPTION##* } -t
    local expected_output="${output}"
    local expected_status=${status}

    run getopts_long-${BATS_TEST_DESCRIPTION##* } -t
    local actual_output="${output}"
    local actual_status=${status}

    test "${expected_output}" == "${actual_output}"
    test "${expected_status}" == "${actual_status}"
}

@test "${FEATURE}: short option, silent" {
    run getopts-${BATS_TEST_DESCRIPTION##* } -t
    local expected_output="${output}"
    local expected_status=${status}

    run getopts_long-${BATS_TEST_DESCRIPTION##* } -t
    local actual_output="${output}"
    local actual_status=${status}

    test "${expected_output}" == "${actual_output}"
    test "${expected_status}" == "${actual_status}"
}

@test "${FEATURE}: long option, verbose" {
    run getopts-${BATS_TEST_DESCRIPTION##* } -t
    local expected_output="${output}"
    local expected_status=${status}

    run getopts_long-${BATS_TEST_DESCRIPTION##* } --toggle
    local actual_output="${output}"
    local actual_status=${status}

    show_output
    test "${expected_output}" == "${actual_output}"
    test "${expected_status}" == "${actual_status}"
}

@test "${FEATURE}: long option, silent" {
    run getopts-${BATS_TEST_DESCRIPTION##* } -t
    local expected_output="${output}"
    local expected_status=${status}

    run getopts_long-${BATS_TEST_DESCRIPTION##* } --toggle
    local actual_output="${output}"
    local actual_status=${status}

    test "${expected_output}" == "${actual_output}"
    test "${expected_status}" == "${actual_status}"
}
