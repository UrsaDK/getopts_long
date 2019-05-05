workflow "test" {
  resolves = ["local.test"]
  on = "push"
}

action "local.test" {
  uses = "./."
  runs = "/etc/entrypoint.d/login_shell"
  env = {
    DEF_BR = "$(date)"
  }
  args = "cd /home && echo DEF_BR=${DEF_BR} && ./bin/test"
}





workflow "publish" {
  resolves = ["docker.push"]
  on = "release"
}

action "docker.login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "docker.image" {
  uses = "actions/docker/cli@master"
  secrets = ["DOCKER_USERNAME"]
  args = "image build --tag ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:${GITHUB_SHA:0:7} --tag ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:${GITHUB_REF##*/} ."
}

action "docker.image" {
  uses = "actions/docker/cli@master"
  secrets = ["DOCKER_USERNAME"]
  args = "image build --tag ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:latest https://github.com/${GITHUB_REPOSITORY}"
}

action "docker.push" {
  uses = "actions/docker/cli@master"
  secrets = ["DOCKER_USERNAME"]
  needs = ["docker.login", "docker.image"]
  args = "image push ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
}
