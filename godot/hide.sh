#!/usr/bin/zsh

model=$1
mkdir -p /tmp/hidden

cd Tasks
for f in *; do;
    if [[ "$f" != "$model" ]]; then
        echo mv $f /tmp/hidden
    fi
done
