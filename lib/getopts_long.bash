# getopts_long ':ar:-: all require:' OPTKEY "${@}"
getopts_long() {
    : ${1:?Missing required parameter -- long optspec}
    : ${2:?Missing required parameter -- variable name}
    : ${3:?Missing required parameter -- command line arguments}

    # echo ">>> OPTARG [${OPTARG}]"
    # echo ">>>    \$1 ${1}"
    # echo ">>>    \$2 ${2}"

    local optspec_short="${1%% *}-:"
    local optspec_long="${1#* }"

    getopts "${optspec_short}" ${2} "${@}" || return 1

    local optkey="${OPTARG%%=*}"
    local optarg="${OPTARG#"${optkey}="}"

    shift 2

    __invalid_option() {
        if [[ "${optspec_short:0:1}" == ':' ]]; then
            OPTARG="${optkey}" && optkey='?'
        else
            unset OPTARG && optkey='?'
        fi
        exit 1
    }

    __missing_argument() {
        if [[ "${optspec_short:0:1}" == ':' ]]; then
            OPTARG="${optkey}" && optkey=':'
        else
            optkey='?' && unset OPTARG
            echo "${1:?Missing required parameter -- error message}" >&2
        fi
        exit 1
    }

    if [[ "${optspec_long}" =~ (^|[[:space:]])${optkey}:?([[:space:]]|$) ]]; then

        if [[ -z "${OPTARG}" ]]; then
            OPTARG="${!OPTIND}" && OPTIND=$(( OPTIND + 1 ))
            if [[ -z "${OPTARG}" ]]; then
                __missing_argument "Missing required argument for option -- ${optkey}"
            fi
        fi
    else
        __invalid_option
    fi

    printf -v ${2} "${optkey}"
    OPTARG="${optarg}"

    # echo "--> OPTKEY [${OPTKEY}]"
    # echo "--> OPTARG [${OPTARG}]"
}
