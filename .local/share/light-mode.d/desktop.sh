#!/bin/sh

rm -rf ~/.config/waybar/.theme.css
rm -rf ~/.config/wofi/.theme.css
rm -rf ~/.config/foot/.theme.ini

ln -s ~/.config/foot/light.ini ~/.config/foot/.theme.ini
ln -s ~/.config/waybar/light.css ~/.config/waybar/.theme.css
ln -s ~/.config/wofi/light.css ~/.config/wofi/.theme.css

pkill -SIGUSR1 foot
