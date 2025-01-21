#!/bin/bash

# This check the decrypted files and see if they have any difference
# between the encrypted ones.

__decrypt_and_save_to_temp() {
    local file current_file_out
    file="$1"
    current_file_out=$(mktmp -s"$TMP_SUFFIX")

    ./src/bin/decrypt.sh "$file" >"$current_file_out"
    echo "$current_file_out"
}

TMP_SUFFIX=".clean"

trap '{ rm -f /tmp/*$TMP_SUFFIX ; }' SIGINT SIGTERM EXIT

dots_modified="$(cd dots && ../src/bin/staged-files.sh)"

if [ -n "$dots_modified" ]; then
    echo -e "Diffing modified files...\n"
else
    echo -e "Nothing to diff here..."
fi

for dot_modified in $dots_modified; do
    gpg_file="$(cat ENV_ENCRYPTED_PATH)/${dot_modified}.gpg"

    encrypted_path="$(cat ENV_ENCRYPTED_PATH)"
    decrypted_path="$(cat ENV_DECRYPTED_PATH)"

    decrypted_text=$(
        sed -e "s;$encrypted_path;$decrypted_path;" \
            -e "s;\.gpg$;;" \
            <<<"$gpg_file"
    )

    encrypted_text="$(__decrypt_and_save_to_temp "$gpg_file")"
    git diff --no-index "$encrypted_text" "$decrypted_text" || true
done
