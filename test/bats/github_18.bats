#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-nounset'

@test "${FEATURE}: toggles, silent" {
    compare '-t -t -- user_arg' \
            '-t --toggle -- user_arg'
}
@test "${FEATURE}: toggles, verbose" {
    compare '-t -t -- user_arg' \
            '-t --toggle -- user_arg'
}

@test "${FEATURE}: options, silent" {
    compare '-o user_val1 -o user_val2 -- user_arg' \
            '-o user_val1 --option user_val2 -- user_arg'
}
@test "${FEATURE}: options, verbose" {
    compare '-o user_val1 -o user_val2 -- user_arg' \
            '-o user_val1 --option user_val2 -- user_arg'
}

@test "${FEATURE}: variables, silent" {
    compare '-vuser_val1 -vuser_val2 -- user_arg' \
            '-vuser_val1 --variable=user_val2 -- user_arg'
}
@test "${FEATURE}: variables, verbose" {
    compare '-vuser_val1 -vuser_val2 -- user_arg' \
            '-vuser_val1 --variable=user_val2 -- user_arg'
}

@test "${FEATURE}: missing last argument, silent" {
    compare '-vuser_val1 -vuser_val2 -- user_arg' \
            '-vuser_val1 --variable=user_val2 -- user_arg'
}
@test "${FEATURE}: missing last argument, verbose" {
    compare '-o' \
            '--option' \
            '1{s/getopts.+verbose:/getopts-NORMALIZED:/}' \
            '1{s/(option requires an argument --) (o|option)$/\1 NORMALIZED/}'
}
