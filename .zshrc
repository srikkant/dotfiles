if [[ -e "$HOME/.antidote/antidote.zsh" ]]; then
    source "$HOME/.antidote/antidote.zsh"
    antidote load
    autoload -U compinit && compinit
fi

bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_find_no_dups

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# Aliases.
alias -g ls="ls --color"
alias -g c="clear"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

PS1='%3~ %# '
