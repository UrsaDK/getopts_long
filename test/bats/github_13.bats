#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-github_13'

@test "${FEATURE}: long option, silent" {
    compare '-o user_val' \
            '--option user_val'
}
@test "${FEATURE}: long option, verbose" {
    compare '-o user_val' \
            '--option user_val'
}

@test "${FEATURE}: long variable, silent" {
    compare '-v user_val' \
            '--variable=user_val' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[4]}" == 'OPTIND: 3'
    expect "${getopts_long_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long variable, verbose" {
    compare '-v user_val' \
            '--variable=user_val' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[4]}" == 'OPTIND: 3'
    expect "${getopts_long_lines[4]}" == 'OPTIND: 2'
}

@test "${FEATURE}: toggle followed by long variable, silent" {
    compare '-t -v user_val' \
            '--toggle --variable=user_val' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[5]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[5]}" == 'OPTIND: 3'
}
@test "${FEATURE}: toggle followed by long variable, verbose" {
    compare '-t -v user_val' \
            '--toggle --variable=user_val' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[5]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[5]}" == 'OPTIND: 3'
}

@test "${FEATURE}: long variable followed by toggle, silent" {
    compare '-v user_val -t' \
            '--variable=user_val --toggle' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[5]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[5]}" == 'OPTIND: 3'
}
@test "${FEATURE}: long variable followed by toggle, verbose" {
    compare '-v user_val -t'  \
            '--variable=user_val --toggle' \
            '/^OPTIND: /d'
    expect "${bash_getopts_lines[5]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[5]}" == 'OPTIND: 3'
}

@test "${FEATURE}: terminator followed by long variable, silent" {
    compare '-t -- -v user_val' \
            '--toggle -- --variable=user_val' \
            '/^\$@: /d'
    expect "${bash_getopts_lines[5]}" == '$@: -v user_val'
    expect "${getopts_long_lines[5]}" == '$@: --variable=user_val'
}
@test "${FEATURE}: terminator followed by long variable, verbose" {
    compare '-t -- -v user_val' \
            '--toggle -- --variable=user_val' \
            '/^\$@: /d'
    expect "${bash_getopts_lines[5]}" == '$@: -v user_val'
    expect "${getopts_long_lines[5]}" == '$@: --variable=user_val'
}

@test "${FEATURE}: long variable followed by terminator, silent" {
    compare '-v user_val -- -t' \
            '--variable=user_val -- --toggle' \
            '/^(OPTIND|\$@): /d'
    expect "${bash_getopts_lines[4]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[4]}" == 'OPTIND: 3'
    expect "${bash_getopts_lines[5]}" == '$@: -t'
    expect "${getopts_long_lines[5]}" == '$@: --toggle'
}
@test "${FEATURE}: long variable followed by terminator, verbose" {
    compare '-v user_val -- -t'  \
            '--variable=user_val -- --toggle' \
            '/^(OPTIND|\$@): /d'
    expect "${bash_getopts_lines[4]}" == 'OPTIND: 4'
    expect "${getopts_long_lines[4]}" == 'OPTIND: 3'
    expect "${bash_getopts_lines[5]}" == '$@: -t'
    expect "${getopts_long_lines[5]}" == '$@: --toggle'
}
