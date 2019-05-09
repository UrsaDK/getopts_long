action "Login to Docker Hub" {
  uses = "actions/docker/login@master"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD"
  ]
}

workflow "Continuous Deployment" {
  on = "push"
  resolves = [
    "Build and tag the latest image",
    "Push the latest image to Docker Hub"
  ]
}

action "Branch is master" {
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Build and tag the latest image" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
   args = [
    "image", "build",
    "--tag", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:latest",
    "."
  ]
}

action "Push the latest image to Docker Hub" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  needs = [
    "Login to Docker Hub",
    "Branch is master",
    "Build and tag the latest image"
  ]
  args = [
    "image", "push", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
  ]
}

workflow "Versioned Release" {
  on = "release"
  resolves = [
    "Push release image to Docker Hub"
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
