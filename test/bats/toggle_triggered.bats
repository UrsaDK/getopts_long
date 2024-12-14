#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: short option, silent" {
    compare '-t' \
            '-t'
}
@test "${FEATURE}: short option, verbose" {
    compare '-t' \
            '-t'
}

@test "${FEATURE}: long option, silent" {
    compare '-t' \
            '--toggle'
}
@test "${FEATURE}: long option, verbose" {
    compare '-t' \
            '--toggle'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    compare '-t user_arg' \
            '-t user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    compare '-t user_arg' \
            '-t user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    compare '-t user_arg' \
            '--toggle user_arg'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    compare '-t user_arg' \
            '--toggle user_arg'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    compare '-t -- user_arg' \
            '-t -- user_arg'
    expect  "${getopts_long[6]}" == '$@: user_arg'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    compare '-t -- user_arg' \
            '-t -- user_arg'
    expect  "${getopts_long[6]}" == '$@: user_arg'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    compare '-t -- user_arg' \
            '--toggle -- user_arg'
    expect  "${getopts_long[6]}" == '$@: user_arg'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    compare '-t -- user_arg' \
            '--toggle -- user_arg'
    expect  "${getopts_long[6]}" == '$@: user_arg'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    compare '-t -t' \
            '-t -t'
    expect  "${getopts_long[1]}" == "${getopts_long[2]}"
    expect  "${getopts_long[1]}" == 'toggle triggered -- OPTARG'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    compare '-t -t' \
            '-t -t'
    expect  "${getopts_long[1]}" == "${getopts_long[2]}"
    expect  "${getopts_long[1]}" == 'toggle triggered -- OPTARG'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    compare '-t -t' \
            '--toggle --toggle'
    expect  "${getopts_long[1]}" == "${getopts_long[2]}"
    expect  "${getopts_long[1]}" == 'toggle triggered -- OPTARG'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    compare '-t -t' \
            '--toggle --toggle'
    expect  "${getopts_long[1]}" == "${getopts_long[2]}"
    expect  "${getopts_long[1]}" == 'toggle triggered -- OPTARG'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    compare '-- -t user_arg' \
            '-- -t user_arg'
    expect  "${getopts_long[5]}" == '$@: -t user_arg'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    compare '-- -t user_arg' \
            '-- -t user_arg'
    expect  "${getopts_long[5]}" == '$@: -t user_arg'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    compare '-- -t user_arg' \
            '-- --toggle user_arg' \
            '/^\$@: /d'
    expect  "${getopts_long[5]}" == '$@: --toggle user_arg'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    compare '-- -t user_arg' \
            '-- --toggle user_arg' \
            '/^\$@: /d'
    expect  "${getopts_long[5]}" == '$@: --toggle user_arg'
}
