workflow "New workflow" {
  resolves = ["local.test", "docker.push"]
  on = "push"
}

action "local.test" {
  uses = "./."
  runs = "/etc/entrypoint.d/login_shell"
  args = "cd /home && ./bin/test"
}

action "github.filter" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "docker.login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "docker.image" {
  uses = "actions/docker/cli@master"
  secrets = ["DOCKER_USERNAME"]
  args = "image build --tag ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:latest ."
}

action "docker.push" {
  uses = "actions/docker/cli@master"
  secrets = ["DOCKER_USERNAME"]
  needs = ["github.filter", "docker.login", "docker.image"]
  args = "image push ${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
}
