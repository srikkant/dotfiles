if status is-interactive
    # Commands to run in interactive sessions can go here
end

# pnpm
set -gx PNPM_HOME "/Users/srikkant/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end