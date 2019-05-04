workflow "New workflow" {
  on = "push"
  resolves = ["getopts_long.test"]
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

action "getopts_long.test" {
  uses = "docker://$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]'):$(echo ${GITHUB_SHA} | hear -c7)"
  needs = ["docker.push"]
  runs = ["/bin/bash", "-l", "-c", "cd /home && ./bin/test"]
}
