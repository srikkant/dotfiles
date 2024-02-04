# dotfiles

this repository contains all dotfiles I require for setting up a new workspace/device.
right now, it is a very simple set of defaults for my two devices - windows (wsl) & macbook (osx).

### tools used

- **terminal emulator**:
- **wezterm**: main terminal
- **kitty**: terminal specifically for wsl
- **nvim**: editor
- **lf**: file explorer

### steps to be followed

- clone the repo
- install homebrew - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- install stow - `brew install stow`
- run stow to create the required symlinks to your home directory (`~`) from the current directory - `stow ~ .`

### assets folder

- `assets/wallpapers/`: contains my wallpaper now, used as a background for wezterm & kitty.
- `assets/fonts/`: contains a ligaturized version of DM Mono
