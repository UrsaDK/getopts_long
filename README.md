<img src="https://umka.dk/getopts_logo/logo.png" alt="getopts_long" align="left" height="70">

**Version:** 1.0.0 <br>
**Status:** Fully functional

<br>

# Getopts_long

This is a pure BASH implementation of `getopts_long` function, which expands on bash built-in `getopts` by implementing support for GNU style long options, such as `--option`, `--option value`, and `--option=value`.

Getopts_long interface is 100% compatible with the explicit use of the shell uilt-in `getopts`. The function is implemented with no external dependencies, and relies solely on BASH built-in tools to provide all of its functionality.

To use it, you can either check out this repository and source the `./lib/getopts_long.bash` file in your script, like so:

```
source "${PATH_TO_THIS_REPO}/lib/getopts_long.bash"
```

or simply cut-n-paste the function into your script.

**NOTE:** `getopts_long` does not support the implicit syntax of the built-in `getopts`. Where the later function can be used with only two parameters (optspec & variable name), while omitting the list of arguments to process, `getopts_long` requires you to explicitly list the arguments.

## Usage

The base-syntax for `getopts` is the same as the explisit syntax for BASH built-in `getopts`:

``` bash
getopts_long OPTSPEC VARNAME ARGS...
```

where:

| name    | description |
| ------- | ----------- |
| OPTSPEC | a list of expected options and arguments |
| VARNAME | a shell-variable to use for option reporting |
| ARGS    | a list of arguments to parse, eg: `"${@}"` |

### OPTSPEC: expected options and arguments

The OPTSPEC tells `getopts_long` which options to expect and which of them must have an argument. The syntax is very simple:

- single-character options are named first (identical to the built-in `getopts`);
- long options follow the single-character options, they are named as is and separated from each other by a space.

Just like with the original `getopts`, when you want `getopts_long` to expect an argument for an option, just place a `:` (colon) after the option.

For example, given the following invocation:

``` bash
getopts_long 'af: all file:' OPTKEY "${@}"
```

the function will recognise the following options:

- `-a` - a single character (short) option with no argument;
- `-f ARG` - a single character (short) option with an argument;
- `--all` - a multi-character (long) option with no argument;
- `--file ARG` - a multi-character (long) option with an argument.

If the very first character of the optspec-string is a `:` (colon), which would normally be nonsense because there's no option letter preceding it, `getopts_long` switches to "silent error reporting mode". In productive scripts, this is usually what you want because it allows you to handle errors yourself without being disturbed by annoying messages.

### Usage example

The following is a simple example of using the function in a script:

``` bash
OPTSPEC=':af: all file:'
while getopts_long "${OPTSPEC}" 'OPTKEY' "${@}"; do
    case ${OPTKEY} in
        'a'|'all')
            echo 'all triggered'
            ;;
        'f'|'file')
            echo "file supplied -- ${OPTARG}"
            ;;
        '?')
            [[ "${OPTSPEC:0:1}" == ':' ]] \
                && echo "INVALID OPTION -- ${OPTARG}" >&2
                || echo "INVALID OPTION or MISSING ARGUMENT" >&2
            exit 1
            ;;
        ':')
            echo "MISSING ARGUMENT for option -- ${OPTARG}" >&2
            exit 1
            ;;
        *)
            echo "Misconfigured OPTSPEC or uncaught option -- ${OPTKEY}" >&2
            exit 1
            ;;
    esac
done

shift $(( OPTIND - 1 ))
[[ "${1}" == "--" ]] && shift
```

## How it works

In general the use of `getopts_long` is identical to that of BASH built-in `getopts`: you need to call `getopts_long` several times. Each time it will use the next positional parameter and a possible argument, if parsable, and provide it to you. The function will not change the set of positional parameters. If you want to shift them, it must be done manually:

``` bash
shift $((OPTIND-1))
# now do something with $@
```

Just like `getopts`, `getopts_long` sets an exit status to FALSE when there's nothing left to parse. Thus, it's easy to use in a while-loop:

``` bash
while getopts ...; do
  ...
done
```

Identical to `getopts`, `getopts_long` will parse options and their possible arguments. It will stop parsing on the first non-option argument (a string that doesn't begin with a hyphen (`-`) that isn't an argument for any option in front of it). It will also stop parsing when it sees the `--` (double-hyphen), which means end of options.

Like the original `getopts`, `getopts_long` sets the following variables:

| variable | description |
| -------- | ----------- |
| OPTIND   | Holds the index to the next argument to be processed. This is how the function "remembers" its own status between invocations. OPTIND is initially set to 1, and **needs to be re-set to 1 if you want to parse anything again with getopts**. |
| OPTARG   | This variable is set to any argument for an option found by `getopts_long`. It also contains the option flag of an unknown option. |
| OPTERR   | (Values 0 or 1) Indicates if Bash should display error messages generated by `getopts_long`. The value is initialised to 1 on every shell startup - so be sure to always set it to 0 if you don't want to see annoying messages! <br><br> OPTERR is not specified by POSIX for the getopts builtin utility — only for the C getopt() function in unistd.h (opterr). OPTERR is bash-specific and not supported by shells such as ksh93, mksh, zsh, or dash. |

## Error reporting

Regarding error-reporting, there are two modes `getopts_long` can run in:

- verbose mode
- silent mode

For productive scripts I recommend using the silent mode, since everything looks more professional, when you don't see annoying standard messages. Also it's easier to handle, since the failure cases are indicated by assigning distinct characters to `VARNAME`.

### Verbose mode

| Error type                  | What happens |
| --------------------------- | ------------ |
| invalid option              | `VARNAME` is set to `?` (question-mark) and `OPTARG` is unset. |
| required argument not found | `VARNAME` is set to `?` (question-mark), `OPTARG` is unset and an _error message is printed_. |

### Silent mode

| Error type                  | What happens |
| --------------------------- | ------------ |
| invalid option              | `VARNAME` is set to `?` (question-mark) and `OPTARG` is set to the (invalid) option character. |
| required argument not found | `VARNAME` is set to `:` (colon) and `OPTARG` contains the option in question. |

## Tests

In order to run the tests you need to have [Bash Automated Testing System (BATS)](https://github.com/bats-core/bats-core) installed. Please consult [their repository](https://github.com/bats-core/bats-core) for the installation instructions.

Once `bats` is installed, `getopts_long` test suit can be run simply be executing the following command in the top directory of this repo:

```
bats tests
```
