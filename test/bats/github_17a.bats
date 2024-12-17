#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-with_extdebug'

@test "${FEATURE}: toggles, silent" {
    compare '-t -t -- user_arg' \
            'toggles'
}
@test "${FEATURE}: toggles, verbose" {
    compare '-t -t -- user_arg' \
            'toggles'
}

@test "${FEATURE}: options, silent" {
    compare '-o user_val1 -o user_val2 -- user_arg' \
            'options'
}
@test "${FEATURE}: options, verbose" {
    compare '-o user_val1 -o user_val2 -- user_arg' \
            'options'
}

@test "${FEATURE}: variables, silent" {
    compare '-vuser_val1 -vuser_val2 -- user_arg' \
            'variables'
}
@test "${FEATURE}: variables, verbose" {
    compare '-vuser_val1 -vuser_val2 -- user_arg' \
            'variables'
}
