#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: short option, silent" {
    run_tests   '-o user_val' \
                '-o user_val'
}
@test "${FEATURE}: short option, verbose" {
    run_tests   '-o user_val' \
                '-o user_val'
}

@test "${FEATURE}: long option, silent" {
    run_tests   '-o user_val' \
                '--option user_val'
}
@test "${FEATURE}: long option, verbose" {
    run_tests   '-o user_val' \
                '--option user_val'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    run_tests   '-o user_val user_arg' \
                '-o user_val user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    run_tests   '-o user_val user_arg' \
                '-o user_val user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    run_tests   '-o user_val user_arg' \
                '--option user_val user_arg'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    run_tests   '-o user_val user_arg' \
                '--option user_val user_arg'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    run_tests   '-o user_val -- user_arg' \
                '-o user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    run_tests   '-o user_val -- user_arg' \
                '-o user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    run_tests   '-o user_val -- user_arg' \
                '--option user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    run_tests   '-o user_val -- user_arg' \
                '--option user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    run_tests   '-o user_val1 -o user_val2' \
                '-o user_val1 -o user_val2'
    test "${actual_lines[0]}" == 'option supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'option supplied -- OPTARG=user_val2'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    run_tests   '-o user_val1 -o user_val2' \
                '-o user_val1 -o user_val2'
    test "${actual_lines[0]}" == 'option supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'option supplied -- OPTARG=user_val2'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    run_tests   '-o user_val1 -o user_val2' \
                '--option user_val1 --option user_val2'
    test "${actual_lines[0]}" == 'option supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'option supplied -- OPTARG=user_val2'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    run_tests   '-o user_val1 -o user_val2' \
                '--option user_val1 --option user_val2'
    test "${actual_lines[0]}" == 'option supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'option supplied -- OPTARG=user_val2'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    run_tests   '-- -o user_val user_arg' \
                '-- -o user_val user_arg'
    test "${actual_lines[4]}" == '$@: -o user_val user_arg'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    run_tests   '-- -o user_val user_arg' \
                '-- -o user_val user_arg'
    test "${actual_lines[4]}" == '$@: -o user_val user_arg'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    run_tests   '-- -o user_val user_arg' \
                '-- --option user_val user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --option user_val user_arg'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    run_tests   '-- -o user_val user_arg' \
                '-- --option user_val user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --option user_val user_arg'
}

# option without an argument

@test "${FEATURE}: short option, missing value, silent" {
    run_tests   '-o' \
                '-o'
}
@test "${FEATURE}: short option, missing value, verbose" {
    run_tests   '-o' \
                '-o' \
                's/getopts_long-verbose/getopts-verbose/g'
}

@test "${FEATURE}: long option, missing value, silent" {
    run_tests   '-o' \
                '--option' \
                '/^MISSING ARGUMENT -- /d'
    test "${expected_lines[0]}" == 'MISSING ARGUMENT -- OPTARG=o'
    test "${actual_lines[0]}" == 'MISSING ARGUMENT -- OPTARG=option'
}
@test "${FEATURE}: long option, missing value, verbose" {
    run_tests   '-o' \
                '--option' \
                's/getopts_long-verbose: (.*) option$/getopts-verbose: \1 o/g'
}
