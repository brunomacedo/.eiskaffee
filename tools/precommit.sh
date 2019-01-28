#!/bin/sh

branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$branch" = "master" ]; then
  echo "You can't push directly to master branch. Please make a Pull Request"
  exit 1
fi
