#!/bin/bash -e

cd "$(cat ENV_DECRYPTED_PATH)"

test -d .git || git init > /dev/null

../src/bin/commit.sh
