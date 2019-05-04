#!/usr/bin/env bats

load ../test_helper

@test "${FEATURE}: short option, silent" {
    compare '-i' \
            '-i'
}
@test "${FEATURE}: short option, verbose" {
    compare '-i' \
            '-i' \
            's/getopts_long-verbose/getopts-verbose/g'
}

@test "${FEATURE}: long option, silent" {
    compare '-i' \
            '--invalid' \
            '/^INVALID OPTION -- /d'
    expect  "${expected_lines[0]}" == 'INVALID OPTION -- OPTARG=i'
    expect  "${actual_lines[0]}" == 'INVALID OPTION -- OPTARG=invalid'
}
@test "${FEATURE}: long option, verbose" {
    compare '-i' \
            '--invalid' \
            's/getopts_long-verbose: (.*) invalid$/getopts-verbose: \1 i/g'
}

# extra arguments

@test "${FEATURE}: short option, extra arguments, silent" {
    compare '-i user_arg' \
            '-i user_arg'
}
# @test "${FEATURE}: short option, extra arguments, verbose" {
#     compare '-i user_arg' \
#             '-i user_arg' \
#             's/getopts_long-verbose/getopts-verbose/g'
# }
#
# @test "${FEATURE}: long option, extra arguments, silent" {
#     compare '-i user_arg' \
#             '--invalid user_arg' \
#             '/^INVALID OPTION -- /d'
#     expect  "${expected_lines[0]}" == 'INVALID OPTION -- OPTARG=i'
#     expect  "${actual_lines[0]}" == 'INVALID OPTION -- OPTARG=invalid'
# }
# @test "${FEATURE}: long option, extra arguments, verbose" {
#     compare '-i user_arg' \
#             '--invalid user_arg' \
#             's/getopts_long-verbose: (.*) invalid$/getopts-verbose: \1 i/g'
# }
#
# # extra arguments with terminator
#
# @test "${FEATURE}: short option, terminator, extra arguments, silent" {
#     compare '-i -- user_arg' \
#             '-i -- user_arg'
#     expect  "${actual_lines[5]}" == '$@: user_arg'
# }
# @test "${FEATURE}: short option, terminator, extra arguments, verbose" {
#     compare '-i -- user_arg' \
#             '-i -- user_arg' \
#             's/getopts_long-verbose/getopts-verbose/g'
#     expect  "${actual_lines[6]}" == '$@: user_arg'
# }
#
# @test "${FEATURE}: long option, terminator, extra arguments, silent" {
#     compare '-i -- user_arg' \
#             '--invalid -- user_arg' \
#             '/^INVALID OPTION -- /d'
#     expect  "${expected_lines[0]}" == 'INVALID OPTION -- OPTARG=i'
#     expect  "${actual_lines[0]}" == 'INVALID OPTION -- OPTARG=invalid'
#     expect  "${actual_lines[5]}" == '$@: user_arg'
# }
# @test "${FEATURE}: long option, terminator, extra arguments, verbose" {
#     compare '-i -- user_arg' \
#             '--invalid -- user_arg' \
#             's/getopts_long-verbose: (.*) invalid$/getopts-verbose: \1 i/g'
#     expect  "${actual_lines[6]}" == '$@: user_arg'
# }
#
# # terminator followed by options
#
# @test "${FEATURE}: terminator, short option, extra arguments, silent" {
#     compare '-- -i user_arg' \
#             '-- -i user_arg'
#     expect  "${actual_lines[4]}" == '$@: -i user_arg'
# }
# @test "${FEATURE}: terminator, short option, extra arguments, verbose" {
#     compare '-- -i user_arg' \
#             '-- -i user_arg' \
#             's/getopts_long-verbose/getopts-verbose/g'
#     expect  "${actual_lines[4]}" == '$@: -i user_arg'
# }
#
# @test "${FEATURE}: terminator, long option, extra arguments, silent" {
#     compare '-- -i user_arg' \
#             '-- --invalid user_arg' \
#             '/^\$@: /d'
#     expect  "${actual_lines[4]}" == '$@: --invalid user_arg'
# }
# @test "${FEATURE}: terminator, long option, extra arguments, verbose" {
#     compare '-- -i user_arg' \
#             '-- --invalid user_arg' \
#             '/^\$@: /d'
#     expect  "${actual_lines[4]}" == '$@: --invalid user_arg'
# }
