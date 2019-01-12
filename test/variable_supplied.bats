#!/usr/bin/env bats

load test_helper

@test "${FEATURE}: short option, silent" {
    run_tests   '-v user_val' \
                '-v user_val'
}
@test "${FEATURE}: short option, verbose" {
    run_tests   '-v user_val' \
                '-v user_val'
}

@test "${FEATURE}: long option, silent" {
    run_tests   '-v user_val' \
                '--variable=user_val' \
                '/^OPTIND: /d'
    test "${expected_lines[4]}" == 'OPTIND: 3'
    test "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, verbose" {
    run_tests   '-v user_val' \
                '--variable=user_val' \
                '/^OPTIND: /d'
    test "${expected_lines[4]}" == 'OPTIND: 3'
    test "${actual_lines[4]}" == 'OPTIND: 2'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    run_tests   '-v user_val user_arg' \
                '-v user_val user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    run_tests   '-v user_val user_arg' \
                '-v user_val user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    run_tests   '-v user_val user_arg' \
                '--variable=user_val user_arg' \
                '/^OPTIND: /d'
    test "${expected_lines[4]}" == 'OPTIND: 3'
    test "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    run_tests   '-v user_val user_arg' \
                '--variable=user_val user_arg' \
                '/^OPTIND: /d'
    test "${expected_lines[4]}" == 'OPTIND: 3'
    test "${actual_lines[4]}" == 'OPTIND: 2'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    run_tests   '-v user_val -- user_arg' \
                '-v user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    run_tests   '-v user_val -- user_arg' \
                '-v user_val -- user_arg'
    test "${actual_lines[5]}" == '$@: user_arg'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    run_tests   '-v user_val -- user_arg' \
                '--variable=user_val -- user_arg' \
                '/^OPTIND: /d'
    test "${actual_lines[5]}" == '$@: user_arg'
    test "${expected_lines[4]}" == 'OPTIND: 4'
    test "${actual_lines[4]}" == 'OPTIND: 3'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    run_tests   '-v user_val -- user_arg' \
                '--variable=user_val -- user_arg' \
                '/^OPTIND: /d'
    test "${actual_lines[5]}" == '$@: user_arg'
    test "${expected_lines[4]}" == 'OPTIND: 4'
    test "${actual_lines[4]}" == 'OPTIND: 3'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    run_tests   '-v user_val1 -v user_val2' \
                '-v user_val1 -v user_val2'
    test "${actual_lines[0]}" == 'variable supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'variable supplied -- OPTARG=user_val2'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    run_tests   '-v user_val1 -v user_val2' \
                '-v user_val1 -v user_val2'
    test "${actual_lines[0]}" == 'variable supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'variable supplied -- OPTARG=user_val2'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    run_tests   '-v user_val1 -v user_val2' \
                '--variable=user_val1 --variable=user_val2' \
                '/^OPTIND: /d'
    test "${actual_lines[0]}" == 'variable supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'variable supplied -- OPTARG=user_val2'
    test "${expected_lines[5]}" == 'OPTIND: 5'
    test "${actual_lines[5]}" == 'OPTIND: 3'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    run_tests   '-v user_val1 -v user_val2' \
                '--variable=user_val1 --variable=user_val2' \
                '/^OPTIND: /d'
    test "${actual_lines[0]}" == 'variable supplied -- OPTARG=user_val1'
    test "${actual_lines[1]}" == 'variable supplied -- OPTARG=user_val2'
    test "${expected_lines[5]}" == 'OPTIND: 5'
    test "${actual_lines[5]}" == 'OPTIND: 3'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    run_tests   '-- -v user_val user_arg' \
                '-- -v user_val user_arg'
    test "${actual_lines[4]}" == '$@: -v user_val user_arg'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    run_tests   '-- -v user_val user_arg' \
                '-- -v user_val user_arg'
    test "${actual_lines[4]}" == '$@: -v user_val user_arg'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    run_tests   '-- -v user_val user_arg' \
                '-- --variable=user_val user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --variable=user_val user_arg'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    run_tests   '-- -v user_val user_arg' \
                '-- --variable=user_val user_arg' \
                '/^\$@: /d'
    test "${actual_lines[4]}" == '$@: --variable=user_val user_arg'
}
