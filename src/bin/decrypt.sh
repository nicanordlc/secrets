#!/bin/bash -e

ENCRYPTED_FILE="${1:?File to decrypt}"

gpg -d "$ENCRYPTED_FILE" 2> /dev/null
