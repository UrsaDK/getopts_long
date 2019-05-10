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
    "cd /home/coverage",
    "&& bash <(curl -s https://codecov.io/bash) -t ${CODECOV_TOKEN}"
  ]
}
