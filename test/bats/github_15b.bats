#!/usr/bin/env bats

load ../test_helper

# Both bash getopts and getopts_long OPTSPEC includes [-]
export GETOPTS_TEST_BIN='getopts-github_15b'
export GETOPTS_LONG_TEST_BIN='getopts_long-github_15b'

# Bash getopts should see four toggles: -t -- -- -t
# Getopts_long should see three toggles: -t --- -t
@test "${FEATURE}: short toggle, silent" {
    compare '-t-- -t user_arg' \
            '-t-- -t user_arg' \
            '4{/^toggle triggered/d}'
}
@test "${FEATURE}: short toggle, verbose" {
    compare '-t-- -t user_arg' \
            '-t-- -t user_arg' \
            '4{/^toggle triggered/d}'
}

# Bash getopts should see four toggles: -t -- -- -t
# Getopts_long should see an invalid option (--toggle--) and a toggle
@test "${FEATURE}: long toggle, silent" {
    compare '-t-- -t user_arg' \
            '--toggle-- --toggle user_arg' \
            '/^toggle triggered/d' \
            '/^INVALID OPTION --/d'
    expect "${bash_getopts_lines[0]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[1]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[2]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[3]}" == 'toggle triggered -- OPTARG is unset'
    expect "${getopts_long_lines[0]}" == 'INVALID OPTION -- OPTARG=toggle--'
    expect "${getopts_long_lines[1]}" == 'toggle triggered -- OPTARG is unset'
}
@test "${FEATURE}: long toggle, verbose" {
    compare '-t-- -t user_arg' \
            '--toggle-- --toggle user_arg' \
            '/^toggle triggered/d' \
            '/illegal option -- toggle--$/d' \
            '/^INVALID OPTION or MISSING ARGUMENT --/d'
    expect "${bash_getopts_lines[0]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[1]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[2]}" == 'toggle triggered -- OPTARG is unset'
    expect "${bash_getopts_lines[3]}" == 'toggle triggered -- OPTARG is unset'
    expect "${getopts_long_lines[0]}" =~ 'getopts_long-\w+-verbose: illegal option -- toggle--'
    expect "${getopts_long_lines[2]}" == 'toggle triggered -- OPTARG is unset'
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
    expect "${bash_getopts_lines[0]}" == 'option supplied -- OPTARG=--'
    expect "${getopts_long_lines[0]}" == 'INVALID OPTION -- OPTARG=option--'
}
@test "${FEATURE}: long option, verbose" {
    compare '-o-- -t user_arg' \
            '--option-- --toggle user_arg' \
            '1{/(option supplied|illegal option)/d}' \
            '2{/^INVALID OPTION or MISSING ARGUMENT/d}'
    expect "${bash_getopts_lines[0]}" == 'option supplied -- OPTARG=--'
    expect "${getopts_long_lines[0]}" =~ 'getopts_long-\w+-verbose: illegal option -- option--$'
}
