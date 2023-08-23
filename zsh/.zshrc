export P4PORT=perforce:1666

export EDITOR=hx
export APPEARANCE=dark
export COLORTERM=truecolor
export HELIX_RUNTIME="$HOME/tools/helix/runtime"
export NVM_DIR="$HOME/.nvm"
export ZSH_DIR="$HOME/.zsh"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd j zsh)"

source "$HOME/.cargo/env"
source "$NVM_DIR/nvm.sh"  
source "$NVM_DIR/bash_completion"  
source "$ZSH_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Aliases.
alias -g reload="source ~/.zshrc"
alias -g pwsh="/mnt/c/Program\ Files/PowerShell/7-preview/pwsh.exe -WorkingDirectory C:"
alias -g ls="lsd"
