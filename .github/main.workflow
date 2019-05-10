workflow "Continuous Deployment" {
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
    "&& export CODECOV_TOKEN='${CODECOV_TOKEN}'",
    "&& bash <(curl -s https://codecov.io/bash)"
  ]
}
