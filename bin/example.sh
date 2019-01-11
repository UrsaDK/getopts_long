#!/usr/bin/env bash

source "$(git rev-parse --show-toplevel)/lib/getopts_long.bash"

while getopts_long ':ta:v: toggle arg: value:' OPTKEY "${@}"; do
    case ${OPTKEY} in
        't'|'toggle')
            echo "toggle triggered with: -t / --toggle"
            ;;
        'a'|'arg')
            echo "argument supplied via: -a ${OPTARG} / --arg ${OPTARG}"
            ;;
        'v'|'value')
            echo "value supplied via: -v=${OPTARG} / --value=${OPTARG}"
            ;;
        '?')
            if [[ -z "${OPTARG}" ]]; then
                echo "INVALID OPTION or MISSING ARGUMENT"
            else
                echo "INVALID OPTION -- ${OPTARG}"
            fi
            ;;
        ':')
            echo "MISSING ARGUMENT for option -- ${OPTARG}"
            ;;
        *)
            echo "NEVER REACHED"
            ;;
    esac
done

shift $(( OPTIND - 1 ))
[[ "${1}" == "--" ]] && shift

echo "COMMANDS: ${@}"
