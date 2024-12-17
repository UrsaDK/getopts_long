#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-github_26'

@test "${FEATURE}: toggle, silent" {
    compare '-t user_arg' \
            '---toggle user_arg'
}
@test "${FEATURE}: toggle, verbose" {
    compare '-t user_arg' \
            '---toggle user_arg'
}

@test "${FEATURE}: option, silent" {
    compare '-o user_val' \
            '---option user_val'
}
@test "${FEATURE}: option, verbose" {
    compare '-o user_val' \
            '---option user_val'
}
