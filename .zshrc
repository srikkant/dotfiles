# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"
# Load bash aliases if present.
[ -s "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

export NVM_DIR="$HOME/.nvm"
export ZSH_DIR="$HOME/.zsh"

export EDITOR=nvim

export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'

eval "$(starship init zsh)"
eval "$(zoxide init --cmd j zsh)"

source "$HOME/.cargo/env"
source "$NVM_DIR/nvm.sh"  

# Aliases.
alias -g c="clear"
alias -g z="zellij"
alias -g reload="source ~/.zshrc"
alias -g ffzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# plugins!
if [ -z "${DISABLE_ZSH_PLUGINS}" ]; then
    source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.post.zsh"
