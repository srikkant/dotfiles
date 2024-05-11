# Load bash aliases if present.
[ -s "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

export EDITOR=nvim

export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

eval "$(starship init zsh)"
eval "$(zoxide init --cmd j zsh)"

# Aliases.
alias -g c="clear"
alias -g z="zellij"
alias -g reload="source ~/.zshrc"
alias -g ffzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

