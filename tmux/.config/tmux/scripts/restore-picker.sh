#!/usr/bin/env bash
# Pick a saved tmux-resurrect layout via fzf and restore it.
set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESURRECT_DIR="$CURRENT_DIR/../plugins/tmux-resurrect/scripts"

source "$RESURRECT_DIR/variables.sh"
source "$RESURRECT_DIR/helpers.sh"

dir="$(resurrect_dir)"
last_link="$dir/last"

cd "$dir"

# list save files newest first, skip the "last" symlink itself
mapfile -t files < <(ls -t ${RESURRECT_FILE_PREFIX}_*.${RESURRECT_FILE_EXTENSION} 2>/dev/null)

if [ ${#files[@]} -eq 0 ]; then
	tmux display-message "No saved tmux environments found."
	exit 0
fi

# build "label  |  date" list for fzf
menu=""
for f in "${files[@]}"; do
	raw="${f#${RESURRECT_FILE_PREFIX}_}"
	raw="${raw%.${RESURRECT_FILE_EXTENSION}}"
	ts="${raw:0:15}"
	label="${raw:16}"
	date_fmt="$(date -d "${ts:0:8} ${ts:9:2}:${ts:11:2}:${ts:13:2}" "+%Y-%m-%d %H:%M" 2>/dev/null || echo "$ts")"
	[ -n "$label" ] && display="$label  ($date_fmt)" || display="$date_fmt"
	menu+="$display"$'\t'"$f"$'\n'
done

chosen_file="$(printf '%s' "$menu" | fzf --with-nth=1 --delimiter=$'\t' --prompt="restore> " | cut -f2)"

if [ -z "$chosen_file" ]; then
	exit 0
fi

ln -sf "$chosen_file" "$last_link"
"$RESURRECT_DIR/restore.sh"
