#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: short option, silent" {
    compare '-v user_val' \
            '-v user_val'
}
@test "${FEATURE}: short option, verbose" {
    compare '-v user_val' \
            '-v user_val'
}

@test "${FEATURE}: long option, silent" {
    compare '-v user_val' \
            '--variable=user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, verbose" {
    compare '-v user_val' \
            '--variable=user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    compare '-v user_val user_arg' \
            '-v user_val user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    compare '-v user_val user_arg' \
            '-v user_val user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    compare '-v user_val user_arg' \
            '--variable=user_val user_arg' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    compare '-v user_val user_arg' \
            '--variable=user_val user_arg' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    compare '-v user_val -- user_arg' \
            '-v user_val -- user_arg'
    expect "${actual_lines[5]}" == '$@: user_arg'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    compare '-v user_val -- user_arg' \
            '-v user_val -- user_arg'
    expect "${actual_lines[5]}" == '$@: user_arg'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    compare '-v user_val -- user_arg' \
            '--variable=user_val -- user_arg' \
            '/^OPTIND: /d'
    expect "${actual_lines[5]}" == '$@: user_arg'
    expect "${expected_lines[4]}" == 'OPTIND: 4'
    expect "${actual_lines[4]}" == 'OPTIND: 3'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    compare '-v user_val -- user_arg' \
            '--variable=user_val -- user_arg' \
            '/^OPTIND: /d'
    expect "${actual_lines[5]}" == '$@: user_arg'
    expect "${expected_lines[4]}" == 'OPTIND: 4'
    expect "${actual_lines[4]}" == 'OPTIND: 3'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    compare '-v user_val1 -v user_val2' \
            '-v user_val1 -v user_val2'
    expect "${actual_lines[0]}" == 'value supplied -- OPTARG=user_val1'
    expect "${actual_lines[1]}" == 'value supplied -- OPTARG=user_val2'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    compare '-v user_val1 -v user_val2' \
            '-v user_val1 -v user_val2'
    expect "${actual_lines[0]}" == 'value supplied -- OPTARG=user_val1'
    expect "${actual_lines[1]}" == 'value supplied -- OPTARG=user_val2'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    compare '-v user_val1 -v user_val2' \
            '--variable=user_val1 --variable=user_val2' \
            '/^OPTIND: /d'
    expect "${actual_lines[0]}" == 'value supplied -- OPTARG=user_val1'
    expect "${actual_lines[1]}" == 'value supplied -- OPTARG=user_val2'
    expect "${expected_lines[5]}" == 'OPTIND: 5'
    expect "${actual_lines[5]}" == 'OPTIND: 3'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    compare '-v user_val1 -v user_val2' \
            '--variable=user_val1 --variable=user_val2' \
            '/^OPTIND: /d'
    expect "${actual_lines[0]}" == 'value supplied -- OPTARG=user_val1'
    expect "${actual_lines[1]}" == 'value supplied -- OPTARG=user_val2'
    expect "${expected_lines[5]}" == 'OPTIND: 5'
    expect "${actual_lines[5]}" == 'OPTIND: 3'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    compare '-- -v user_val user_arg' \
            '-- -v user_val user_arg'
    expect "${actual_lines[4]}" == '$@: -v user_val user_arg'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    compare '-- -v user_val user_arg' \
            '-- -v user_val user_arg'
    expect "${actual_lines[4]}" == '$@: -v user_val user_arg'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    compare '-- -v user_val user_arg' \
            '-- --variable=user_val user_arg' \
            '/^\$@: /d'
    expect "${actual_lines[4]}" == '$@: --variable=user_val user_arg'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    compare '-- -v user_val user_arg' \
            '-- --variable=user_val user_arg' \
            '/^\$@: /d'
    expect "${actual_lines[4]}" == '$@: --variable=user_val user_arg'
}

# variable without an argument

@test "${FEATURE}: short option, missing value, silent" {
    compare '-v' \
            '-v'
}
@test "${FEATURE}: short option, missing value, verbose" {
    compare '-v' \
            '-v' \
            's/getopts_long-verbose/getopts-verbose/g'
}

@test "${FEATURE}: long option, missing value, silent" {
    compare '-v' \
            '--variable' \
            '/^MISSING ARGUMENT -- /d'
    expect "${expected_lines[0]}" == 'MISSING ARGUMENT -- OPTARG=v'
    expect "${actual_lines[0]}" == 'MISSING ARGUMENT -- OPTARG=variable'
}
@test "${FEATURE}: long option, missing value, verbose" {
    compare '-v' \
            '--variable' \
            's/getopts_long-verbose: (.*) variable$/getopts-verbose: \1 v/g'
}

# option with a value that start with a dash

@test "${FEATURE}: short option, value starts with -, silent" {
    compare '-v -user_val' \
            '-v -user_val'
}
@test "${FEATURE}: short option, value starts with -, verbose" {
    compare '-v -user_val' \
            '-v -user_val'
}

@test "${FEATURE}: long option, value starts with -, silent" {
    compare '-v -user_val' \
            '--variable=-user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, value starts with -, verbose" {
    compare '-v -user_val' \
            '--variable=-user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}

# option with a value that start with an equals sign

@test "${FEATURE}: short option, value starts with =, silent" {
    compare '-v =user_val' \
            '-v =user_val'
}
@test "${FEATURE}: short option, value starts with =, verbose" {
    compare '-v =user_val' \
            '-v =user_val'
}

@test "${FEATURE}: long option, value starts with =, silent" {
    compare '-v =user_val' \
            '--variable==user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}
@test "${FEATURE}: long option, value starts with =, verbose" {
    compare '-v =user_val' \
            '--variable==user_val' \
            '/^OPTIND: /d'
    expect "${expected_lines[4]}" == 'OPTIND: 3'
    expect "${actual_lines[4]}" == 'OPTIND: 2'
}
