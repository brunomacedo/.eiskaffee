# Eiskaffee theme for ZSH
#
# Create a symbolic link:
# ln -s $EISK_HOME/.oh-my-zsh/eiskaffee.zsh-theme $ZSH_CUSTOM/themes/eiskaffee.zsh-theme
# And add to `.zshrc` file `ZSH_THEME="eiskaffee"`
#
# Prompt:
# %F => Color codes
# %f => Reset color
# %~ => Current path
# %(x.true.false) => Specifies a ternary expression
#   ! => True if the shell is running with root privileges
#   ? => True if the exit status of the last command was success
#
# Git:
# %a => Current action (rebase/merge)
# %b => Current branch
# %c => Staged changes
# %u => Unstaged changes
#
# Terminal:
# \n => Newline/Line Feed (LF)

setopt PROMPT_SUBST

autoload -U add-zsh-hook
autoload -Uz vcs_info

# Use True color (24-bit) if available.
if [[ "${terminfo[colors]}" -ge 256 ]]; then
    fg_blue="%F{27}"
    fg_red="%F{167}"
    fg_green="%F{28}"
else
    fg_blue="%F{blue}"
    fg_red="%F{red}"
    fg_green="%F{green}"
fi

# Reset color.
fg_reset_color="%f"

# VCS style formats.
FMT_UNSTAGED="%{$fg_reset_color%} %{$fg_red%}✗"
FMT_STAGED="%{$fg_reset_color%} %{$fg_green%}✚"
FMT_ACTION="(%{$fg_green%}%a%{$fg_reset_color%})"
FMT_VCS_STATUS="on %{$fg_blue%}🔥 %b%u%c%{$fg_reset_color%}"

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr    "${FMT_UNSTAGED}"
zstyle ':vcs_info:*' stagedstr      "${FMT_STAGED}"
zstyle ':vcs_info:*' actionformats  "${FMT_VCS_STATUS} ${FMT_ACTION}"
zstyle ':vcs_info:*' formats        "${FMT_VCS_STATUS}"
zstyle ':vcs_info:*' nvcsformats    ""
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked node-version

# Check for untracked files.
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
            git status --porcelain | grep -m 1 '^??' &> /dev/null; then
        hook_com[staged]+="%{$fg_reset_color%} %{$fg_red%}✚"
    fi
}

# Show nodejs version
+vi-node-version() {
    if which node &> /dev/null; then
        hook_com[staged]+=" %{$fg_reset_color%}($(node -v))"
    fi
}

# Executed before each prompt.
add-zsh-hook precmd vcs_info

# Prompt style.
PROMPT=$'\n%{$fg_green%}%~%{$fg_reset_color%} ${vcs_info_msg_0_}\n%(?.%{%F{white}%}.%{$fg_red%})%(!.#.$)%{$fg_reset_color%} '
