#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-longspec_with_dash'

@test "${FEATURE}: toggle, silent" {
    compare '-t' \
            '---'
}
@test "${FEATURE}: toggle, verbose" {
    compare '-t' \
            '---'
}

@test "${FEATURE}: double toggle, silent" {
    compare '-tt' \
            '--- --toggle' \
            '/^OPTIND: /d'
    expect "${bash_getopts[6]}" == 'OPTIND: 2'
    expect "${getopts_long[6]}" == 'OPTIND: 3'
}
@test "${FEATURE}: double toggle, verbose" {
    compare '-tt' \
            '--- --toggle' \
            '/^OPTIND: /d'
    expect "${bash_getopts[6]}" == 'OPTIND: 2'
    expect "${getopts_long[6]}" == 'OPTIND: 3'
}
