#!/bin/bash

N_DIR=$1
VERSION=$2

if [[ -z "$N_DIR" || -z "$VERSION" ]]; then
    echo "Usage: $0 <N_DIR> <VERSION>"
    exit 1
fi

for DIR in $N_DIR/*; do
    if [[ ! -d "$DIR" ]]; then
        continue
    fi

    FOLDER=$(basename "$DIR")
    VERSION_IN_FOLDER=$(echo "$FOLDER" | sed 's/^[^_]*_\([0-9.]*\).*/\1/')

    if version_gt "$VERSION_IN_FOLDER" "$VERSION"; then
        echo "Deleting $DIR"
        rm -rf "$DIR"
    fi
done

version_gt() {
    test "$(printf '%s\n' "$@" | sort -rV | head -n 1)" != "$1";
}