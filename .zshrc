if [[ -e "$HOME/.antidote/antidote.zsh" ]]; then
    source "$HOME/.antidote/antidote.zsh"
    antidote load
    autoload -U compinit && compinit
fi

bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

export EDITOR=nvim
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export BAT_THEME="base16"

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

eval "$(starship init zsh)"
eval "$(zoxide init --cmd j zsh)"
eval "$(fzf --zsh)"

# Aliases.
alias -g ls="ls --color"
alias -g c="clear"
alias -g ffzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu no
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
