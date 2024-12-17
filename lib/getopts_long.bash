getopts_long() {
    : "${1:?Missing required parameter -- long optspec}"
    : "${2:?Missing required parameter -- variable name}"

    local optspec_short="${1%% *}"
    local optspec_long="${1#* }"
    local optvar="${2}"

    shift 2

    if [[ "${#}" == 0 ]]; then
        local args=()
        local -i start_index=0
        local -i end_index=$(( ${#BASH_ARGV[@]} - 1 ))

        # Minimise the number of times `declare -f` is executed
        if [[ -n "${FUNCNAME[1]}" ]]; then
            if [[ "${FUNCNAME[1]}" == "( anon )" ]] \
                    || declare -f "${FUNCNAME[1]}" > /dev/null 2>&1; then
                if ! shopt -q extdebug; then
                    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}:" \
                    "${FUNCNAME[0]} failed to detect supplied arguments" \
                    "-- enable extdebug or pass arguments explicitly" >&2
                    return 2
                fi
                start_index=${BASH_ARGC[0]}
                end_index=$(( start_index + BASH_ARGC[1] - 1 ))
            fi
        fi

        for (( i = end_index; i >= start_index; i-- )); do
            args+=("${BASH_ARGV[i]}")
        done
        set -- "${args[@]}"
    fi

    # Sanitize and normalize short optspec
    optspec_short="${optspec_short//-:}"
    optspec_short="${optspec_short//-}"
    [[ "${!OPTIND:0:2}" == "--" ]] && optspec_short+='-:'

    builtin getopts -- "${optspec_short}" "${optvar}" "${@}" || return ${?}
    [[ "${!optvar}" == '-' ]] || return 0

    printf -v "${optvar}" "%s" "${OPTARG%%=*}"

    if [[ " ${optspec_long} " == *" ${!optvar}: "* ]]; then
        OPTARG="${OPTARG#"${!optvar}"}"
        OPTARG="${OPTARG#=}"

        # Missing argument
        if [[ -z "${OPTARG}" ]]; then
            OPTARG="${!OPTIND}" && OPTIND=$(( OPTIND + 1 ))
            [[ -z "${OPTARG}" ]] || return 0

            if [[ "${optspec_short:0:1}" == ':' ]]; then
                OPTARG="${!optvar}" && printf -v "${optvar}" ':'
            else
                [[ "${OPTERR}" == 0 ]] || \
                    echo "${0}: option requires an argument -- ${!optvar}" >&2
                unset OPTARG && printf -v "${optvar}" '?'
            fi
        fi
    elif [[ " ${optspec_long} " == *" ${!optvar} "* ]]; then
        unset OPTARG
        declare -g OPTARG
    else
        # Invalid option
        if [[ "${optspec_short:0:1}" == ':' ]]; then
            OPTARG="${!optvar}"
        else
            [[ "${OPTERR}" == 0 ]] || echo "${0}: illegal option -- ${!optvar}" >&2
            unset OPTARG
        fi
        printf -v "${optvar}" '?'
    fi
}
