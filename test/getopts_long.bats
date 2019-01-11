#!/usr/bin/env bats

load test_helper

@test "${TEST_BIN}" {
  run ${BATS_TEST_DESCRIPTION}
  test "${status}" -gt 0
}
