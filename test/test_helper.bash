: ${GIT_TOPLEVEL_DIR:="$(git rev-parse --show-toplevel)"}
: ${GIT_TEST_DIR:="${GIT_TOPLEVEL_DIR}/test"}

: ${TEST_BIN:="${GIT_TOPLEVEL_DIR}/bin/example.sh"}
: ${TEST_CMD:="${EXAMPLE_BIN##*/}"}
