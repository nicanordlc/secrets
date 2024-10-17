#!/bin/bash -e
set -Eeuo pipefail

__prompt(){
    read -rep "Import gpg key (.gpg): " KEY

    if [[ "$KEY" =~ ^[nN]$ ]]; then
        exit 1
    fi
}

__import_key(){
    if ! eval "gpg --import $KEY"; then
        echo "Could not add the key..." 1>&2
        exit 1
    fi
}

# exit if variable is not set
if [ -z "$GPG_ID" ]; then
  exit 1
fi

if gpg --list-secret-keys --keyid-format=long | grep "$GPG_ID" &> /dev/null; then
    exit 0
fi

__prompt
__import_key

