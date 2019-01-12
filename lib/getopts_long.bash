getopts_long() {
    : ${1:?Missing required parameter -- long optspec}
    : ${2:?Missing required parameter -- variable name}

    local optspec_short="${1%% *}-:"
    local optspec_long="${1#* }"
    local optvar="${2}"

    shift 2

    getopts "${optspec_short}" "${optvar}" "${@}" || return 1
    [[ "${!optvar}" == '-' ]] || return 0

    printf -v "${optvar}" "${OPTARG%%=*}"
    OPTARG="${OPTARG#${!optvar}}"

    if [[ "${optspec_long}" =~ (^|[[:space:]])${!optvar}:([[:space:]]|$) ]]; then
        # Missing argument
        if [[ -z "${OPTARG}" ]]; then
            OPTARG="${!OPTIND}" && OPTIND=$(( OPTIND + 1 ))
            [[ -z "${OPTARG}" ]] || return 0

            if [[ "${optspec_short:0:1}" == ':' ]]; then
                OPTARG="${!optvar}" && printf -v "${optvar}" ':'
            else
                unset OPTARG && printf -v "${optvar}" ':'
                echo "${1:?Missing required parameter -- error message}" >&2
            fi
        fi
    elif [[ "${optspec_long}" =~ (^|[[:space:]])${!optvar}([[:space:]]|$) ]]; then
        unset OPTARG
    else
        # Invalid option
        [[ "${optspec_short:0:1}" == ':' ]] && OPTARG="${!optvar}" || unset OPTARG
        printf -v ${optvar} '?'
    fi
}
