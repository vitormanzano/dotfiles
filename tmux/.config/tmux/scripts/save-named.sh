#!/usr/bin/env bash
# Save current tmux layout via tmux-resurrect, tagged with a label.
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESURRECT_DIR="$CURRENT_DIR/../plugins/tmux-resurrect/scripts"

source "$RESURRECT_DIR/variables.sh"
source "$RESURRECT_DIR/helpers.sh"

label="${1:-}"
label="$(echo "$label" | tr -c 'a-zA-Z0-9_-' '_' | sed 's/^_*//;s/_*$//')"

"$RESURRECT_DIR/save.sh" quiet

dir="$(resurrect_dir)"
last_link="$dir/last"
target="$(readlink -f "$last_link")"

if [ -n "$label" ]; then
	new_name="${target%.txt}_${label}.txt"
	mv "$target" "$new_name"
	ln -sf "$(basename "$new_name")" "$last_link"
	tmux display-message "Saved: $label"
else
	tmux display-message "Tmux environment saved!"
fi
