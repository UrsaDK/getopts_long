#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: silent" {
    compare '' ''
}
@test "${FEATURE}: verbose" {
    compare '' ''
}

@test "${FEATURE}: extra arguments, silent" {
    compare 'user_arg' \
            'user_arg'
}
@test "${FEATURE}: extra arguments, verbose" {
    compare 'user_arg' \
            'user_arg'
}

@test "${FEATURE}: terminator, extra arguments, silent" {
    compare '-- user_arg' \
            '-- user_arg'
    expect  "${getopts_long[5]}" == '$@: user_arg'
}
@test "${FEATURE}: terminator, extra arguments, verbose" {
    compare '-- user_arg' \
            '-- user_arg'
    expect  "${getopts_long[5]}" == '$@: user_arg'
}
