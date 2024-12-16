#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: short option, silent" {
    compare '-o user_val' \
            '-o user_val'
}
@test "${FEATURE}: short option, verbose" {
    compare '-o user_val' \
            '-o user_val'
}

@test "${FEATURE}: long option, silent" {
    compare '-o user_val' \
            '--option user_val'
}
@test "${FEATURE}: long option, verbose" {
    compare '-o user_val' \
            '--option user_val'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    compare '-o user_val user_arg' \
            '-o user_val user_arg'
}
@test "${FEATURE}: short option, extra arguments, verbose" {
    compare '-o user_val user_arg' \
            '-o user_val user_arg'
}

@test "${FEATURE}: long option, extra arguments, silent" {
    compare '-o user_val user_arg' \
            '--option user_val user_arg'
}
@test "${FEATURE}: long option, extra arguments, verbose" {
    compare '-o user_val user_arg' \
            '--option user_val user_arg'
}

# extra arguments with terminator

@test "${FEATURE}: short option, terminator, extra arguments, silent" {
    compare '-o user_val -- user_arg' \
            '-o user_val -- user_arg'
    expect  "${getopts_long[6]}" == '$@: ([0]="user_arg")'
}
@test "${FEATURE}: short option, terminator, extra arguments, verbose" {
    compare '-o user_val -- user_arg' \
            '-o user_val -- user_arg'
    expect  "${getopts_long[6]}" == '$@: ([0]="user_arg")'
}

@test "${FEATURE}: long option, terminator, extra arguments, silent" {
    compare '-o user_val -- user_arg' \
            '--option user_val -- user_arg'
    expect  "${getopts_long[6]}" == '$@: ([0]="user_arg")'
}
@test "${FEATURE}: long option, terminator, extra arguments, verbose" {
    compare '-o user_val -- user_arg' \
            '--option user_val -- user_arg'
    expect  "${getopts_long[6]}" == '$@: ([0]="user_arg")'
}

# multiple same arguments

@test "${FEATURE}: short option, multiple same arguments, silent" {
    compare '-o user_val1 -o user_val2' \
            '-o user_val1 -o user_val2'
    expect  "${getopts_long[1]}" == 'option supplied -- OPTARG="user_val1"'
    expect  "${getopts_long[2]}" == 'option supplied -- OPTARG="user_val2"'
}
@test "${FEATURE}: short option, multiple same arguments, verbose" {
    compare '-o user_val1 -o user_val2' \
            '-o user_val1 -o user_val2'
    expect  "${getopts_long[1]}" == 'option supplied -- OPTARG="user_val1"'
    expect  "${getopts_long[2]}" == 'option supplied -- OPTARG="user_val2"'
}

@test "${FEATURE}: long option, multiple same arguments, silent" {
    compare '-o user_val1 -o user_val2' \
            '--option user_val1 --option user_val2'
    expect  "${getopts_long[1]}" == 'option supplied -- OPTARG="user_val1"'
    expect  "${getopts_long[2]}" == 'option supplied -- OPTARG="user_val2"'
}
@test "${FEATURE}: long option, multiple same arguments, verbose" {
    compare '-o user_val1 -o user_val2' \
            '--option user_val1 --option user_val2'
    expect  "${getopts_long[1]}" == 'option supplied -- OPTARG="user_val1"'
    expect  "${getopts_long[2]}" == 'option supplied -- OPTARG="user_val2"'
}

# terminator followed by options

@test "${FEATURE}: terminator, short option, extra arguments, silent" {
    compare '-- -o user_val user_arg' \
            '-- -o user_val user_arg'
    expect  "${getopts_long[5]}" == '$@: ([0]="-o" [1]="user_val" [2]="user_arg")'
}
@test "${FEATURE}: terminator, short option, extra arguments, verbose" {
    compare '-- -o user_val user_arg' \
            '-- -o user_val user_arg'
    expect  "${getopts_long[5]}" == '$@: ([0]="-o" [1]="user_val" [2]="user_arg")'
}

@test "${FEATURE}: terminator, long option, extra arguments, silent" {
    compare '-- -o user_val user_arg' \
            '-- --option user_val user_arg' \
            '/^\$@: /d'
    expect  "${getopts_long[5]}" == '$@: ([0]="--option" [1]="user_val" [2]="user_arg")'
}
@test "${FEATURE}: terminator, long option, extra arguments, verbose" {
    compare '-- -o user_val user_arg' \
            '-- --option user_val user_arg' \
            '/^\$@: /d'
    expect  "${getopts_long[5]}" == '$@: ([0]="--option" [1]="user_val" [2]="user_arg")'
}

# option without an argument

@test "${FEATURE}: short option, missing value, silent" {
    compare '-o' \
            '-o'
}
@test "${FEATURE}: short option, missing value, verbose" {
    compare '-o' \
            '-o' \
            's/getopts_long-verbose/getopts-verbose/g'
}

@test "${FEATURE}: long option, missing value, silent" {
    compare '-o' \
            '--option' \
            '/^MISSING ARGUMENT -- /d'
    expect  "${bash_getopts[1]}" == 'MISSING ARGUMENT -- OPTARG="o"'
    expect  "${getopts_long[1]}" == 'MISSING ARGUMENT -- OPTARG="option"'
}
@test "${FEATURE}: long option, missing value, verbose" {
    compare '-o' \
            '--option' \
            's/getopts_long-verbose: (.*) option$/getopts-verbose: \1 o/g'
}

# option with a value that start with a dash

@test "${FEATURE}: short option, value starts with -, silent" {
    compare '-o -user_val' \
            '-o -user_val'
}
@test "${FEATURE}: short option, value starts with -, verbose" {
    compare '-o -user_val' \
            '-o -user_val'
}

@test "${FEATURE}: long option, value starts with -, silent" {
    compare '-o -user_val' \
            '--option -user_val'
}
@test "${FEATURE}: long option, value starts with -, verbose" {
    compare '-o -user_val' \
            '--option -user_val'
}

# option with a value that start with an equals sign

@test "${FEATURE}: short option, value starts with =, silent" {
    compare '-o =user_val' \
            '-o =user_val'
}
@test "${FEATURE}: short option, value starts with =, verbose" {
    compare '-o =user_val' \
            '-o =user_val'
}

@test "${FEATURE}: long option, value starts with =, silent" {
    compare '-o =user_val' \
            '--option =user_val'
}
@test "${FEATURE}: long option, value starts with =, verbose" {
    compare '-o =user_val' \
            '--option =user_val'
}

# option with an adjoined value

@test "${FEATURE}: short option, adjoined value, silent" {
    compare '-ouser_val' \
            '-ouser_val'
}
@test "${FEATURE}: short option, adjoined value, verbose" {
    compare '-ouser_val' \
            '-ouser_val'
}

@test "${FEATURE}: long option, adjoined value, silent" {
    compare '-ouser_val' \
            '--optionuser_val' \
            '1d'
    expect  "${bash_getopts[1]}" == 'option supplied -- OPTARG="user_val"'
    expect  "${getopts_long[1]}" == 'INVALID OPTION -- OPTARG="optionuser_val"'

}

@test "${FEATURE}: long option, adjoined value, verbose" {
    compare '-ouser_val' \
            '--optionuser_val' \
            '1d' \
            '2{/^INVALID OPTION or MISSING ARGUMENT/d}'
    expect  "${bash_getopts[1]}" == 'option supplied -- OPTARG="user_val"'
    expect  "${getopts_long[1]}" =~ 'getopts_long-verbose: illegal option -- optionuser_val'
}
