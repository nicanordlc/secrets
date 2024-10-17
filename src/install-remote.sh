#!/bin/bash
set -Eeuo pipefail

main() {
  local $GIT_USERNAME
  local $GIT_REPO

  # make sure projects directory is ready
  mkdir -p "$HOME/projects"

  # clone secrets and cd to it
  cd "$HOME/projects/"
  git clone "https://github.com/$GIT_USERNAME/$GIT_REPO" secrets || true
  cd secrets

  # start gpg key initialization and decription of the files
  make init
}

main "$@"
