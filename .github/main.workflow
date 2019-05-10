workflow "Codecov" {
  on = "push"
  resolves = [
    "Publish coverage report"
  ]
}

action "Publish coverage report" {
  uses = "./."
  secrets = [
    "CODECOV_TOKEN"
  ]
  runs = "/etc/entrypoint.d/login_shell"
  args = [
    "cd ${GITHUB_WORKSPACE}",
    "&& echo \">>>> PWD=${PWD}\"",
    "&& echo '>>>> <ci_env>'",
    "&& bash <(curl -s https://codecov.io/env)",
    "&& echo '>>>> </ci_env>'",
    "&& echo \">>>> CODECOV_ENV=${CODECOV_ENV}\"",
    "&& cd /home/coverage",
    "&& echo \">>>> CODECOV_TOKEN=${CODECOV_TOKEN}\"",
    "&& bash <(curl -s https://codecov.io/bash) -t ${CODECOV_TOKEN}"
  ]
}
