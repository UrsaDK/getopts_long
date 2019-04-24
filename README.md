<div align="center">

  ![getopts_long](./images/logo.png)<br>

  ![project version: 1.2.0](https://img.shields.io/badge/version-1.2.0-blue.svg)
  ![test coverage: 100%](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)
  [![donate via coinbase](https://img.shields.io/badge/donate-coinbase-gold.svg?colorB=ff8e00&logo=bitcoin)](https://commerce.coinbase.com/checkout/17ae30c2-9c3f-45fb-a911-36d01a3c81b6)

</div>

# getopts_long

This is a pure BASH implementation of `getopts_long` function, which "upgrades" bash built-in `getopts` with support for GNU style long options, such as:

  - `--option`
  - `--option value`
  - `--option=value`

This function is 100% compatible with the built-in `getopts`. It is implemented with no external dependencies, and relies solely on BASH built-in tools to provide all of its functionality.

## Table of Content

- [Installation](#installation)
- [Usage](#usage)
  - [Extended OPTSPEC](#extended-optspec)
  - [Example script](#example-script)
- [How it works](#how-it-works)
  - [Error reporting](#error-reporting)
    - [Verbose mode](#verbose-mode)
    - [Silent mode](#silent-mode)
- [Contributions](#contributions)
  - [Test Suite](#test-suite)
  - [Quick Launch](#quick-launch)
  - [Container Shell](#container-shell)

## Installation

There are two alternative ways to install and use the function:

- Source the function in your script

  The function is distributed via a single self-contained file: `lib/getopts_long.bash`. To use the function in your script the file needs to be sourced in your script, which means that you need to have a local copy of this repository. So, cone the repository with:

  ```
  git clone https://github.com/UmkaDK/getopts_long.git
  ```

  Then update your script to include the following:

  ```
  source "__PATH_TO__/getopts_long/lib/getopts_long.bash"
  ```

- Cut-n-paste the content of `lib/getopts_long.bash` into your script.

## Usage

The syntax for `getopts_long` is the same as the syntax for the built-in `getopts`:

``` bash
getopts_long OPTSPEC VARNAME [ARGS...]
```

where:

| Name    | Description |
| ------- | ----------- |
| OPTSPEC | An extended list of expected options and their arguments. |
| VARNAME | A shell-variable to use for option reporting. |
| ARGS    | an optional list of arguments to parse. If omitted then `getopts_long` will parse arguments supplied to the script. |

### Extended OPTSPEC

An OPTSPEC string tells `getopts_long` which options to expect and which of them must have an argument. The syntax is very simple:

- single-character options are named first (identical to the built-in `getopts`);
- long options follow the single-character options, they are named as is and are separated from each other and the single-character options by a space.

Just like with the original `getopts`, when you want `getopts_long` to expect an argument for an option, just place a `:` (colon) after the option.

For example, given `'af: all file:'` as the OPTSPEC string, `getopts_long` will recognise the following options:

- `-a` - a single character (short) option with no argument;
- `-f ARG` - a single character (short) option with an argument;
- `--all` - a multi-character (long) option with no argument;
- `--file ARG` - a multi-character (long) option with an argument.

If the very first character of the optspec-string is a `:` (colon), which would normally be nonsense because there's no option letter preceding it, `getopts_long` switches to "silent error reporting mode" (See [Error Reporting](#error-reporting) for more info).

In production scripts, "silent mode" is usually what you want because it allows you to handle errors yourself without being distracted by default error messages. It's also easier to handle, since the failure cases are indicated by assigning distinct characters to `VARNAME`.

### Example script

A good example is worth a thousand words, so here is an example of how you could use the function within a script:

``` bash
#!/usr/bin/env bash
source "${PATH_TO_REPO}/lib/getopts_long.bash"

while getopts_long ':af: all file:' OPTKEY; do
    case ${OPTKEY} in
        'a'|'all')
            echo 'all triggered'
            ;;
        'f'|'file')
            echo "file supplied -- ${OPTARG}"
            ;;
        '?')
            echo "INVALID OPTION -- ${OPTARG}" >&2
            exit 1
            ;;
        ':')
            echo "MISSING ARGUMENT for option -- ${OPTARG}" >&2
            exit 1
            ;;
        *)
            echo "UNIMPLEMENTED OPTION -- ${OPTKEY}" >&2
            exit 1
            ;;
    esac
done

shift $(( OPTIND - 1 ))
[[ "${1}" == "--" ]] && shift

...
```

## How it works

In general the use of `getopts_long` is identical to that of BASH built-in `getopts`. Just like the builtin function, you need to call `getopts_long` several times. Each time it will use the next positional parameter and a possible argument, if parsable, and provide it to you. The function will not change the set of positional parameters. If you want to shift them, it must be done manually:

``` bash
shift $(( OPTIND - 1 ))
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

| Variable | Description |
| -------- | ----------- |
| OPTIND   | Holds the index to the next argument to be processed. This is how the function "remembers" its own status between invocations. OPTIND is initially set to 1, and **needs to be re-set to 1 if you want to parse anything again with getopts**. |
| OPTARG   | This variable is set to any argument for an option found by `getopts_long`. It also contains the option flag of an unknown option. |
| OPTERR   | (Values 0 or 1) Indicates if Bash should display error messages generated by `getopts_long`. The value is initialised to 1 on every shell startup - so be sure to always set it to 0 if you don't want to see annoying messages! <br><br> OPTERR is not specified by POSIX for the getopts builtin utility — only for the C getopt() function in unistd.h (opterr). OPTERR is bash-specific and not supported by shells such as ksh93, mksh, zsh, or dash. |

### Error reporting

Regarding error-reporting, there are two modes `getopts_long` can run in:

  - verbose mode
  - silent mode

In production scripts I recommend using the silent mode, because it allows you to handle errors yourself without being distracted by default error messages. It's also easier to handle, since the failure cases are indicated by assigning distinct characters to `VARNAME`.

#### Verbose mode

| Error type                  | What happens |
| --------------------------- | ------------ |
| invalid option              | `VARNAME` is set to `?` (question-mark) and `OPTARG` is unset. |
| required argument not found | `VARNAME` is set to `?` (question-mark), `OPTARG` is unset and an _error message is printed_. |

#### Silent mode

| Error type                  | What happens |
| --------------------------- | ------------ |
| invalid option              | `VARNAME` is set to `?` (question-mark) and `OPTARG` is set to the (invalid) option character. |
| required argument not found | `VARNAME` is set to `:` (colon) and `OPTARG` contains the option in question. |

## Contributions

Even though I consider this function feature complete, contributions are always welcome. New ideas, bugs, and pull requests, all will be very much appreciated. The only thing I ask is that if you're submitting a PR, please:

1. Ensure that all existing tests pass;
2. Add all tests required to test your PR.

Test suite for this function is implemented using a [docker](https://docker.com), so you need it installed on your system in order to run the test, generate test coverage reports, and quick launch your scripts.

### Test Suite

Docker image can be built locally with the following command:
```
docker image build --tag getopts_long .
```

Execute the container to run all the tests and to generate a coverage report, which will be placed in the `coverage` subdirectory of the projects root:
```
docker container run --rm --init -it -v ${PWD}:/mnt getopts_long
```

### Quick Launch

Arguments supplied to the `container run` command will be executed in the context of the container with `getopts_long` function exported and made available to them.

In other words, if you want to test if your script works with `getopt_long` function and you have getopts_long docker image available, then you can `cd` into your scripts parent directory and run the script via the container:
```
docker container run --rm --init -it -v ${PWD}:/mnt getopts_long ./my_script
```

### Container Shell

Sometimes it is necessary to have additional control over the container or to investigate its inner workings. In this case, being able to open a shell inside a container is invaluable:
```
docker container run --rm --init -it -v ${PWD}:/mnt getopts_long bash --login
```
