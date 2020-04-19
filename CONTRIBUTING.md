
# Contributions

Even though I consider this function feature complete, contributions are always welcome. New ideas, bugs, and pull requests, all will be very much appreciated. The only thing I ask is that if you're submitting a PR, please:

1. Ensure that all existing tests pass;
2. Add all tests required by your PR.


## The test suite

Tests for this project live in the `./test` subdirectory of the project root. They are implemented using [BATS](https://github.com/bats-core/bats-core) (unit tests), and [Kcov](https://github.com/SimonKagstrom/kcov) (coverage report).

All tools required to build and run the test for the project are provided by the `tools` stage of the Dockerfile. The project also includes an easy shorthand for running all the docker commands:

- Show commands supported by the docker shortcut:

  ``` bash
  ./bin/docker help
  ```

- Build a local docker image, or a specific Dockerfile stage:

  ``` bash
  ./bin/docker build
  # ./bin/docker build tools
  ```

- Launch 'latest' shell container, or run a specific Dockerfile stage:

  ``` bash
  ./bin/docker run
  # ./bin/docker run tools
  ```

- Run the entire test suit, or a specific test:

  ``` bash
  ./bin/docker run latest bats
  # ./bin/docker run latest bats test/bats/invalid_arguments.bats
  ```


## The container

The following locations have special meaning within a running container:

  - `/home` - location of the immutable version of the code. This code is baked into the container and will reset itself to a clean state (discard all changes) every time the container is launched.

  - `/mnt` - a mount-point for your working directory. This folder is mounted by the docker shortcut (`./bin/docker`) and can be used to import you current working directory into the container.

The following tools are provided within the container

  - `shellcheck` - https://github.com/koalaman/shellcheck
  - `bats-core` - https://github.com/bats-core/bats-core
  - `kcov` - https://github.com/SimonKagstrom/kcov
  - `/home/bin/bats` - a custom wrapper around the above three tools that allows you to run shell test and generates a coverage report as long as the root directory of the project includes `bin`, `lib`, and `test` directories, which are used accordingly.
  - `/home/bin/kcov` - a custom wrapper around the `kcov` command which cleans up output reports

Please note that `/home/bin` directory in _pre-pended_ to the shell's PATH variable. As such, all files placed in `/home/bin` will be executed in preference to the system tools. For example, executing `kcov` runs `/home/bin/kcov` not `/usr/local/bin/kcov`.
