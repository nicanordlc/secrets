#!/bin/bash

# Show in plain text any *.gpg in the git-stash.
# You can pass any *.gpg file as arguments too

ALL=$*

STAGED_FILES=$(
./src/bin/staged-files.sh |
    grep "^.*\.gpg$"
)

if [ "$ALL" ]; then
    GPG_FILES=$ALL
else
    GPG_FILES=$STAGED_FILES
fi

for GPG_FILE in $GPG_FILES; do
    echo "$GPG_FILE"
    printf "%0.s-" $(seq 1 ${#GPG_FILE})
    echo
    gpg -d "$GPG_FILE" 2> /dev/null
    printf "%0.s-" $(seq 1 ${#GPG_FILE})
    echo
    echo
done
