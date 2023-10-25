# Load bash aliases if present.
[ -s "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

export EDITOR=hx
export APPEARANCE=dark
export COLORTERM=truecolor
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export HELIX_RUNTIME="$HOME/tools/helix/runtime"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export NVM_DIR="$HOME/.nvm"
export ZSH_DIR="$HOME/.zsh"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd j zsh)"

source "$HOME/.cargo/env"
source "$NVM_DIR/nvm.sh"  
source "$NVM_DIR/bash_completion"  
source "$ZSH_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_DIR/scripts/autols.zsh"

# Aliases.
alias -g c="clear"
alias -g reload="source ~/.zshrc"
alias -g ls="lsd"
alias -g zd="$ZSH_DIR/scripts/zellij-default-session.zsh"
alias -g zide='zellij -l ide'

alias -g ffzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
