# dotfiles

this repository contains all dotfiles I require for setting up a new workspace/device.
right now, it is a very simple set of defaults for my two devices - windows (wsl) & macbook (osx).

### tools used

- **terminal emulator**:
- **wezterm**: main terminal
- **kitty**: terminal specifically for wsl
- **nvim**: editor
- **lf**: file explorer
- **starship**: shell prompt

### steps to be followed after cloning the repo

```
# install homebrew -
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install zsh (incase it is not)
brew install zsh

# install starship
brew install starship

# install stow
brew install stow

# run stow to create the required symlinks to your home directory (`~`) from the current directory
stow ~ .

```

on running this and then trying to open a shell, there might be some errors due to missing tools. 
run the command below to install some useful and frequently used stuff.

```
# install whatever is available through homebrew
brew install pnpm rustup fzf lsd zsh-autosuggestions`

# install nvm 
# once this is done, install some node versions as needed and then install pnpm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```

### assets folder

- `assets/wallpapers/`: contains my wallpaper now, used as a background for wezterm & kitty.
- `assets/fonts/`: contains a ligaturized version of DM Mono
