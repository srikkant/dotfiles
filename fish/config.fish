if status is-interactive
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "/Users/srikkant/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end

starship init fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true
