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
    "bash <(curl -s https://codecov.io/bash) -t ${CODECOV_TOKEN} -R ${GITHUB_WORKSPACE} -s /home/coverage -Z -v"
  ]
}
