# ~/.bash_profile: executed by bash(1) for login shells.

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"
