#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: short option, silent" {
    run_tests   '-t' \
                '-t'
}
@test "${FEATURE}: short option, verbose" {
    run_tests   '-t' \
                '-t'
}

@test "${FEATURE}: long option, silent" {
    run_tests   '-t' \
                '--toggle'
}
@test "${FEATURE}: long option, verbose" {
    run_tests   '-t' \
                '--toggle'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    run_tests   '-t user_arg' \
                '-t user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    run_tests   '-t user_arg' \
                '-t user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    run_tests   '-t user_arg' \
                '--toggle user_arg'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    run_tests   '-t user_arg' \
                '--toggle user_arg'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    run_tests   '-t -- user_arg' \
                '-t -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    run_tests   '-t -- user_arg' \
                '-t -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    run_tests   '-t -- user_arg' \
                '--toggle -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    run_tests   '-t -- user_arg' \
                '--toggle -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    run_tests   '-t -t' \
                '-t -t'
    test "${actual_lines[0]}" == "${actual_lines[1]}"
    test "${actual_lines[0]}" == 'toggle triggered -- OPTARG is unset'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    run_tests   '-t -t' \
                '-t -t'
    test "${actual_lines[0]}" == "${actual_lines[1]}"
    test "${actual_lines[0]}" == 'toggle triggered -- OPTARG is unset'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    run_tests   '-t -t' \
                '--toggle --toggle'
    test "${actual_lines[0]}" == "${actual_lines[1]}"
    test "${actual_lines[0]}" == 'toggle triggered -- OPTARG is unset'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    run_tests   '-t -t' \
                '--toggle --toggle'
    test "${actual_lines[0]}" == "${actual_lines[1]}"
    test "${actual_lines[0]}" == 'toggle triggered -- OPTARG is unset'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    run_tests   '-- -t user_arg' \
                '-- -t user_arg'
    test "${actual_lines[4]}" == '$@: -t user_arg'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    run_tests   '-- -t user_arg' \
                '-- -t user_arg'
    test "${actual_lines[4]}" == '$@: -t user_arg'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    run_tests   '-- -t user_arg' \
                '-- --toggle user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --toggle user_arg'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    run_tests   '-- -t user_arg' \
                '-- --toggle user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --toggle user_arg'
}
