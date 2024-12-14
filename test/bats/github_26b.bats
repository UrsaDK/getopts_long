#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-longspec_with_dash_colon'

@test "${FEATURE}: option, silent" {
    compare '-o user_val' \
            '--- user_val'
}
@test "${FEATURE}: option, verbose" {
    compare '-o user_val' \
            '--- user_val'
}

# geopts_long does not support option-value adjoined syntax for long options.
# Thus, let's compare it to bash getopts command that uses an invalid option.
@test "${FEATURE}: option with adjacent value, silent" {
    compare '-z' \
            '---zz' \
            '/^INVALID OPTION/d'
    expect "${bash_getopts[1]}" == 'INVALID OPTION -- OPTARG="z"'
    expect "${getopts_long[1]}" == 'INVALID OPTION -- OPTARG="-zz"'
}
@test "${FEATURE}: option with adjacent value, verbose" {
    compare '-z' \
            '---zz' \
            '/-verbose: illegal option --/d'
    expect "${bash_getopts[1]}" =~ '-verbose: illegal option -- z'
    expect "${getopts_long[1]}" =~ '-verbose: illegal option -- -zz'
}
