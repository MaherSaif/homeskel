export SSH_STATE_FILE="$HOME/.bashrc.ssh.state"

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

#if not running in tmux yet
if [[ -z "$STY" ]]; then

	# if connected via ssh
	if [[ ! -z "$SSH_TTY" ]]; then
		# if SSH_AUTH_SOCK is not defined, spawn a new ssh-agent
		SSHAGENT="`which ssh-agent`"
		SSHAGENTARGS="-s"
		if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
			eval `$SSHAGENT $SSHAGENTARGS`
			export SSH_SHOULD_KILL_AGENT_ON_STOP="true"
		fi

		# send remote computer current hostname
		if [[ ! -z "$SSH_TTY" ]]; then
			echo -ne "\033]0;${HOSTNAME%%.*}\007"
		fi
	fi

	# dump ssh environment variables
	# idea from: http://www.deadman.org/sshscreen.php
	SSHVARS="SSH_CLIENT SSH_TTY SSH_AUTH_SOCK SSH_CONNECTION DISPLAY"
	for x in ${SSHVARS} ; do
		(eval echo $x=\$$x) | sed -e 's/=/="/g' -e 's/$/"/g' -e 's/^/export /g'
	done 1>"$SSH_STATE_FILE"


	# if connected remotely (or forced)
	if [[ ! -z "$SSH_TTY" || -f "$HOME/.bashrc.tmux.force" || ! -z "$TMUX_FORCE" ]]; then
		if [[ ! -f $HOME/.bashrc.tmux.prevent  && -z "$TMUX_PREVENT" ]]; then
		# spawn new tmux or reattach existing one
			exec "$HOME/.bashrc.tmux.cmd.sh"
			echo "Couldn't exec" 1>&2
			exit 0
		fi
	fi
fi

# make ssh an alias function that updates SSH envs
# and sets
ssh() {
	# fix envs for ssh-agent
	[ -f "$SSH_STATE_FILE" ] && source "$SSH_STATE_FILE"
	
#	if [[ ! -z "$STY" ]]; then
#		trap 'screen -X title "${HOSTNAME%%.*}"' SIGINT
#		# remote name
#		screen -X title "${1##*@}";
#	fi
	command ssh "$@";
#	if [[ ! -z "$STY" ]]; then
#		# restore to current
#		screen -X title "${HOSTNAME%%.*}";
#		trap - SIGINT
#	fi
}

ssh-add() {
	[ -f "$SSH_STATE_FILE" ] && source "$SSH_STATE_FILE"

	command ssh-add "$@";
}
	


