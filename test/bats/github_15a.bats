#!/usr/bin/env bats

load ../test_helper

# Neither bash getopts nor getopts_long OPTSPEC includes [-], but
# getopts_long always appends [-:] to the end of the short OPTSPEC.

# Standard getopts should see:
#   -t          - a toggle
#   --          - an invalid option
#   --          - an invalid option
#   -t          - a toggle
# Getopts_long should see:
#   -t          - a toggle
#   ---         - an invalid option
#   -t          - a toggle
@test "${FEATURE}: short toggle, silent" {
    compare '-t-- -t user_arg' \
            '-t-- -t user_arg' \
            '3{/^INVALID OPTION/d}'
}
@test "${FEATURE}: short toggle, verbose" {
    compare '-t-- -t user_arg' \
            '-t-- -t user_arg' \
            '4{/getopts-verbose: illegal option -- -$/d}' \
            '5{/^INVALID OPTION or MISSING ARGUMENT -- OPTARG is unset$/d}' \
            's/getopts[[:alpha:]_-]*/GETOPTS-NORMALISED/'
}

# Standard getopts should see:
#   -t          - a toggle
#   --          - an invalid option
#   --          - an invalid option
#   -t          - a toggle
# Getopts_long should see:
#   --toggle--  - an invalid option
#   --toggle    - a toggle
@test "${FEATURE}: long toggle, silent" {
    compare '-t-- -t user_arg' \
            '--toggle-- --toggle user_arg' \
            '1{/^toggle triggered/d}' \
            '/^INVALID OPTION/d'
    expect "${bash_getopts[1]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts[2]}" == 'INVALID OPTION -- OPTARG=-'
    expect "${bash_getopts[3]}" == 'INVALID OPTION -- OPTARG=-'
    expect "${bash_getopts[4]}" == 'toggle triggered -- OPTARG is unset'
    expect "${getopts_long[1]}" == 'INVALID OPTION -- OPTARG=toggle--'
    expect "${getopts_long[2]}" == 'toggle triggered -- OPTARG is unset'
}
@test "${FEATURE}: long toggle, verbose" {
    compare '-t-- -t user_arg' \
            '--toggle-- --toggle user_arg' \
            '1{/^toggle triggered/d}' \
            '4{/getopts-verbose: illegal option -- -$/d}' \
            '5{/^INVALID OPTION or MISSING ARGUMENT/d}' \
            's/getopts[[:alpha:]_-]*/GETOPTS-NORMALISED/' \
            's/(illegal option --) (-|toggle--)/\1 TOGGLE-NORMALISED/'
    expect "${bash_getopts[1]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts[2]}" =~ 'getopts-verbose: illegal option -- -$'
    expect "${bash_getopts[4]}" =~ 'getopts-verbose: illegal option -- -$'
    expect "${bash_getopts[6]}" == 'toggle triggered -- OPTARG is unset'
    expect "${getopts_long[1]}" =~ 'getopts_long-verbose: illegal option -- toggle--$'
    expect "${getopts_long[3]}" == 'toggle triggered -- OPTARG is unset'
}

# Both implementations should see:
#   -o --       - an option (-o) with a value (--)
#   -t          - a toggle
@test "${FEATURE}: short option, silent" {
    compare '-o-- -t user_arg' \
            '-o-- -t user_arg'
}
@test "${FEATURE}: short option, verbose" {
    compare '-o-- -t user_arg' \
            '-o-- -t user_arg'
}

# Standard getopts should see:
#   -o --       - an option with a value (--)
#   -t          - a toggle
# Getopts_long should see:
#   --option--  - an invalid option
#   --toggle    - a toggle
@test "${FEATURE}: long option, silent" {
    compare '-o-- -t user_arg' \
            '--option-- --toggle user_arg' \
            '1{/(option supplied|INVALID OPTION)/d}'
    expect "${bash_getopts[1]}" == 'option supplied -- OPTARG=--'
    expect "${getopts_long[1]}" == 'INVALID OPTION -- OPTARG=option--'
}
@test "${FEATURE}: long option, verbose" {
    compare '-o-- -t user_arg' \
            '--option-- --toggle user_arg' \
            '1{/(option supplied|illegal option)/d}' \
            '2{/^INVALID OPTION or MISSING ARGUMENT/d}'
    expect "${bash_getopts[1]}" == 'option supplied -- OPTARG=--'
    expect "${getopts_long[1]}" =~ "getopts_long-verbose: illegal option -- option--$"
}
