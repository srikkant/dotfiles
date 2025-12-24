#!/bin/sh

rm -rf ~/.config/waybar/.theme.css
rm -rf ~/.config/wofi/.theme.css
rm -rf ~/.config/alacritty/.theme.toml

ln -s ~/.config/alacritty/light.toml ~/.config/alacritty/.theme.toml
ln -s ~/.config/waybar/light.css ~/.config/waybar/.theme.css
ln -s ~/.config/wofi/light.css ~/.config/wofi/.theme.css
