workflow "New workflow" {
  on = "push"
  resolves = ["Run docker container"]
}

action "Build docker image" {
  uses = "actions/docker/cli@master"
  args = ["image", "build", "--tag", "$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]'):$(echo ${GITHUB_SHA} | head -c7)", "."]
}

action "Run docker container" {
  uses = "actions/docker/cli@master"
  needs = ["Build docker image"]
  args = ["container", "run", "--rm", "--init", "-v", "${GITHUB_WORKSPACE}:/mnt", "$(echo ${GITHUB_REPOSITORY} | tr '[:upper:]' '[:lower:]'):$(echo ${GITHUB_SHA} | head -c7)"]
}
