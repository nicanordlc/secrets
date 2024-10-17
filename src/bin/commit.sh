#!/bin/bash

git add .

if [ "$(git status --porcelain | wc -w)" -eq 0 ]; then
  exit 0
fi

if git log &> /dev/null; then
    git commit --amend --no-edit --no-verify &> /dev/null
else
    git commit -m "check" &> /dev/null
fi

