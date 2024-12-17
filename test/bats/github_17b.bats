#!/usr/bin/env bats

load ../test_helper

# Compare in the following tests is simply used to populate
# bash_getopts and getopts_long arrays with identical results.
export GETOPTS_TEST_BIN='getopts_long-without_extdebug'
export GETOPTS_LONG_TEST_BIN='getopts_long-without_extdebug'

@test "${FEATURE}: toggles, silent" {
    compare 'toggles' 'toggles'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-silent: line 8: getopts_long failed"
}
@test "${FEATURE}: toggles, verbose" {
    compare 'toggles' 'toggles'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-verbose: line 8: getopts_long failed"
}

@test "${FEATURE}: options, silent" {
    compare 'options' 'options'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-silent: line 8: getopts_long failed"
}
@test "${FEATURE}: options, verbose" {
    compare 'options' 'options'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-verbose: line 8: getopts_long failed"
}

@test "${FEATURE}: variables, silent" {
    compare 'variables' 'variables'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-silent: line 8: getopts_long failed"
}
@test "${FEATURE}: variables, verbose" {
    compare 'variables' 'variables'
    expect "${getopts_long[1]}" =~ "getopts_long-without_extdebug-verbose: line 8: getopts_long failed"
}
