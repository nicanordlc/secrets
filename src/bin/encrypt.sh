#!/bin/bash -e

cd "$(cat ENV_DECRYPTED_PATH)"

git add .

for git_file in $(../src/bin/staged-files.sh); do
    gpg --always-trust -eu "${GPG_ID}" -r "${GPG_ID}" "$git_file"

    target_file_path="../src/encrypted/${git_file}.gpg"

    target_folder_path="${target_file_path%/*}"
    mkdir -p "$target_folder_path"

    mv "${git_file}.gpg" "$target_file_path"
    echo "Encrypted: ${target_file_path//..\//}"
done

../src/bin/commit.sh

cd - &>/dev/null

git add .
