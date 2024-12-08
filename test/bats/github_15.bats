#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: short option, silent" {
    compare '-o-- user_arg' \
            '-o-- user_arg'
}
@test "${FEATURE}: short option, verbose" {
    compare '-o-- user_arg' \
            '-o-- user_arg'
}

@test "${FEATURE}: long option, silent" {
    compare '-o-- user_arg' \
            '--option-- user_arg'
}

@test "${FEATURE}: long option, verbose" {
    compare '-o-- user_arg' \
            '--option-- user_arg'
}
