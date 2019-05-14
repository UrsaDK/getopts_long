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
    "cd /home",
    "&& ln -vsf ${GITHUB_WORKSPACE}/.git",
    "&& bash <(curl -s https://codecov.io/bash) -t ${CODECOV_TOKEN} -n ${GITHUB_REF##*/}:${GITHUB_SHA:0:7} -R /home -p /home -Z"
  ]
}
