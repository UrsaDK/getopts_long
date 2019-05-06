workflow "Versioned Release" {
  on = "release"
  resolves = [
    "Push release image to Docker Hub"
  ]
}

action "Validate event action" {
  uses = "actions/bin/filter@master"
  args = "action 'published|created|edited|prereleased'"
}

action "Login to Docker Hub" {
  uses = "actions/docker/login@master"
  secrets = [
    "DOCKER_USERNAME",
    "DOCKER_PASSWORD"
  ]
}

action "Build and tag repository image" {
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
    "Validate event action",
    "Login to Docker Hub",
    "Build and tag repository image"
  ]
  args = [
    "image", "push", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
  ]
}
