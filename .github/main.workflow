workflow "New workflow" {
  on = "push"
  resolves = ["docker.push"]
}

action "docker.login" {
  uses = "actions/docker/login@master"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "docker.image" {
  uses = "actions/docker/cli@master"
  args = ["image", "build", "--tag", "${GITHUB_SHA}", "."]
}

action "docker.tag" {
  uses = "actions/docker/tag@master"
  needs = ["docker.image"]
  args = ["${GITHUB_SHA}", "$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]')"]
}

action "docker.push" {
  uses = "actions/docker/cli@master"
  needs = ["docker.tag", "docker.login"]
  args = ["image", "push", "$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]')"]
}
