workflow "Continuous Integration" {
  on = "push"
  resolves = [
    "Test and publish coverage report",
    "Push latest image to Docker Hub"
  ]
}

workflow "Versioned Release" {
  on = "release"
  resolves = [
    "Push release image to Docker Hub"
  ]
}

action "Test and publish coverage report" {
  uses = "./."
  secrets = [
    "CODECOV_TOKEN"
  ]
  runs = "/etc/entrypoint.d/login_shell"
  args = [
    "./bin/test /home/coverage",
    "&& cd /home/coverage",
    "&& bash <(curl -s https://codecov.io/bash)"
  ]
}

action "Login to Docker Hub" {
  uses = "actions/docker/login@master"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD"
  ]
}

action "Branch is master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Build and tag latest image" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  needs = [
    "Branch is master",
    "Test and publish coverage report"
  ]
  args = [
    "image", "build",
    "--tag", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:latest",
    "."
  ]
}

action "Push latest image to Docker Hub" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  needs = [
    "Login to Docker Hub",
    "Build and tag latest image"
  ]
  args = [
    "image", "push", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
  ]
}

action "Release is created" {
  uses = "actions/bin/filter@master"
  args = "action 'published|created|edited|prereleased'"
}

action "Build and tag release image" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  args = [
    "image", "build",
    "--tag", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:${GITHUB_SHA:0:7}",
    "--tag", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:${GITHUB_REF##*/}",
    "."
  ]
}

action "Push release image to Docker Hub" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  needs = [
    "Release is created",
    "Login to Docker Hub",
    "Build and tag release image"
  ]
  args = [
    "image", "push", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
  ]
}
