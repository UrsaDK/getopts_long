# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console ...
if [ "$SHLVL" = 1 ]; then
    # clear the screen
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q

    # reset terminal title
    [[ "${TERM}" == xterm* || "${TERM}" == rxvt* ]] && printf '\e]1;\a'
fi
