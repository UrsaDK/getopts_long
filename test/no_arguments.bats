#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: silent" {
    run_tests '' ''
}
@test "${FEATURE}: verbose" {
    run_tests '' ''
}

@test "${FEATURE}: extra arguments, silent" {
    run_tests   'user_arg' \
                'user_arg'
}
@test "${FEATURE}: extra arguments, verbose" {
    run_tests   'user_arg' \
                'user_arg'
}

@test "${FEATURE}: terminator, extra arguments, silent" {
    run_tests   '-- user_arg' \
                '-- user_arg'
    test "${actual_lines[4]}" == '$@: user_arg'
}
@test "${FEATURE}: terminator, extra arguments, verbose" {
    run_tests   '-- user_arg' \
                '-- user_arg'
    test "${actual_lines[4]}" == '$@: user_arg'
}
