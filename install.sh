#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"

files=(
    "zshrc:.zshrc"
    "tmux.conf:.tmux.conf"
    )

for entry in "${files[@]}"; do
    src="${entry%%:*}"
    dst="${entry##*:}"

    src_path="$DOTFILES/$src"
    dst_path="$HOME/$dst"

    if [ ! -e "$src_path" ]; then
        echo "$src - doesn't exist in DOTFILES"
        continue
    fi

    # Backup if the file already exists
    if [ -e  "$dst_path" ] && [ ! -L "$dst_path" ]; then
        echo "Backup $dst_path -> $dst_path.backup"
        mv "$dst_path" "dst_path.backup"
    fi

    ln -sf "$src_path" "$dst_path"
done

echo
echo "Done!"


