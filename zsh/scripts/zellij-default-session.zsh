default_session=$(zellij list-sessions | grep default)

if [[ -n $default_session ]]; then
    zellij attach default
else
    zellij -s default
fi


