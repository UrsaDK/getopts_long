workflow "Continuous Integration" {
  on = "push"
  resolves = [
    "Test and publish coverage report",
    "Push latest build to Docker Hub"
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

action "Validate event branch" {
  uses = "actions/bin/filter@master"
  args = "branch master"
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
    "--tag", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}:latest",
    "."
  ]
}

action "Push latest build to Docker Hub" {
  uses = "actions/docker/cli@master"
  secrets = [
    "DOCKER_USERNAME"
  ]
  needs = [
    "Validate event branch",
    "Login to Docker Hub",
    "Build and tag repository image"
  ]
  args = [
    "image", "push", "${DOCKER_USERNAME}/${GITHUB_REPOSITORY#*/}"
  ]
}
