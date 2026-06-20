# Aliases
alias dc='cd'

# Most used commands 
alias muc='history 1 | awk '"'"'{$1="";print substr($0,2)}'"'"' | sort | uniq -c | sort -n | tail -n 10'

alias rm='rm -iv'

alias nv='nvim'

alias inv='nvim $(fzf -m --preview="bat --color=always {}")'

# todo function
# This function recursively searches for the string TODO from the current directory.
# The match is case-insensitive (todo, Todo, TODO all match).
#
# Usages:
# todo
#   Shows every TODO grep finds in any file under the current directory.
# todo <extension>
#   <extension> restricts the search to *.<extension> files.
#   For instance: `todo py` searches only in .py files.
# todo <extension> <comment_char>
#   <extension> works as above. <comment_char> is the character used to mark
#   comments in the file, so the pattern matches: anything + <comment_char>
#   + (optional space/tab) + TODO. Python uses `#`, so `todo py #` matches
#   both `#TODO` and `# TODO`.
todo() {
    find . -type f -name "*${1:+.$1}" -exec grep -Hin ".*${2:+$2[[:blank:]]*}TODO.*" {} + | awk -F: '{print $1 " - Line:" $2}'
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# zsh plugins
_zsh_autosuggestions=(
    /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
)
_zsh_syntax=(
    /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
for f in $_zsh_autosuggestions; do [ -f "$f" ] && source "$f" && break; done
for f in $_zsh_syntax;          do [ -f "$f" ] && source "$f" && break; done
unset _zsh_autosuggestions _zsh_syntax

ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]=fg=red
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]=fg=red                                                                                                  

#new_tmux () {
#  session_dir=$(zoxide query --list | fzf)
#  session_name=$(basename "$session_dir")
#
#  if tmux has-session -t "$session_name" 2>/dev/null; then
#    if [ -n "$TMUX" ]; then
#      tmux switch-client -t "$session_name"
#    else
#      tmux attach -t "$session_name"
#    fi
#    notification="tmux attached to $session_name"
#  else
#    if [ -n "$TMUX" ]; then
#      tmux new-session -d -c "$session_dir" -s "$session_name" \
#        && tmux switch-client -t "$session_name"
#      notification="new tmux session INSIDE TMUX: $session_name"
#    else
#      tmux new-session -c "$session_dir" -s "$session_name"
#      notification="new tmux session: $session_name"
#    fi
#  fi
#
#  if [ -n "$session_name" ]; then
#    osascript -e "display notification \"$notification\" with title \"tmux\""
#  fi
#}

export GO111MODULE=on
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
 
# format_dir() {
#     local dir="${PWD}"
#     if [[ "$dir" == "$HOME" ]]; then
#         echo "./~"
#     elif [[ "$dir" == "/" ]]; then
#         echo "/"
#     elif [[ "$dir" =~ ^/[^/]+$ ]]; then
#         echo "$dir"
#     else
#         echo "./${PWD##*/}"
#     fi
# }
# 
# parse_git_branch() {
#     local branch
#     branch=$(git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/\1/p')
#     if [ -n "$branch" ]; then
#         echo "%F{39}git(%F{196}${branch}%F{39})"
#     fi
# }
# COLOR_DEF='%f'
# COLOR_USR='%F{231}'
# COLOR_DIR='%F{243}'
# COLOR_GIT='%F{51}'
# COLOR_BRANCH='%F{196}'
# COLOR_X='%F{226}'
# setopt PROMPT_SUBST
# export PROMPT='${COLOR_USR}%n ${COLOR_DIR}$(format_dir) ${COLOR_GIT}$(parse_git_branch)${COLOR_X} ✗${COLOR_DEF} '


 
eval "$(starship init zsh)"
fastfetch --logo ~/.config/fastfetch/mylogo.txt
export PATH="$HOME/.local/bin:$PATH"
