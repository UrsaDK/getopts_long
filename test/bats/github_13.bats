#!/usr/bin/env bats

load ../test_helper
export GETOPTS_LONG_TEST_BIN='getopts_long-no_shortspec'

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
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[5]}" == 'declare -i OPTIND="3"'
    expect "${getopts_long[5]}" == 'declare -i OPTIND="2"'
}
@test "${FEATURE}: long variable, verbose" {
    compare '-v user_val' \
            '--variable=user_val' \
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[5]}" == 'declare -i OPTIND="3"'
    expect "${getopts_long[5]}" == 'declare -i OPTIND="2"'
}

@test "${FEATURE}: toggle followed by long variable, silent" {
    compare '-t -v user_val' \
            '--toggle --variable=user_val' \
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[6]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[6]}" == 'declare -i OPTIND="3"'
}
@test "${FEATURE}: toggle followed by long variable, verbose" {
    compare '-t -v user_val' \
            '--toggle --variable=user_val' \
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[6]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[6]}" == 'declare -i OPTIND="3"'
}

@test "${FEATURE}: long variable followed by toggle, silent" {
    compare '-v user_val -t' \
            '--variable=user_val --toggle' \
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[6]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[6]}" == 'declare -i OPTIND="3"'
}
@test "${FEATURE}: long variable followed by toggle, verbose" {
    compare '-v user_val -t'  \
            '--variable=user_val --toggle' \
            '/^declare -i OPTIND=/d'
    expect "${bash_getopts[6]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[6]}" == 'declare -i OPTIND="3"'
}

@test "${FEATURE}: terminator followed by long variable, silent" {
    compare '-t -- -v user_val' \
            '--toggle -- --variable=user_val' \
            '/^\$@: /d'
    expect "${bash_getopts[6]}" == 'declare -a $@=([0]="-v" [1]="user_val")'
    expect "${getopts_long[6]}" == 'declare -a $@=([0]="--variable=user_val")'
}
@test "${FEATURE}: terminator followed by long variable, verbose" {
    compare '-t -- -v user_val' \
            '--toggle -- --variable=user_val' \
            '/^\$@: /d'
    expect "${bash_getopts[6]}" == 'declare -a $@=([0]="-v" [1]="user_val")'
    expect "${getopts_long[6]}" == 'declare -a $@=([0]="--variable=user_val")'
}

@test "${FEATURE}: long variable followed by terminator, silent" {
    compare '-v user_val -- -t' \
            '--variable=user_val -- --toggle' \
            '/^(OPTIND|\$@): /d'
    expect "${bash_getopts[5]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[5]}" == 'declare -i OPTIND="3"'
    expect "${bash_getopts[6]}" == 'declare -a $@=([0]="-t")'
    expect "${getopts_long[6]}" == 'declare -a $@=([0]="--toggle")'
}
@test "${FEATURE}: long variable followed by terminator, verbose" {
    compare '-v user_val -- -t'  \
            '--variable=user_val -- --toggle' \
            '/^(OPTIND|\$@): /d'
    expect "${bash_getopts[5]}" == 'declare -i OPTIND="4"'
    expect "${getopts_long[5]}" == 'declare -i OPTIND="3"'
    expect "${bash_getopts[6]}" == 'declare -a $@=([0]="-t")'
    expect "${getopts_long[6]}" == 'declare -a $@=([0]="--toggle")'
}
