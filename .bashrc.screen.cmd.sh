#!/bin/bash

screen -xRR -S sshwrap

# clean up after detach'ing
# drop ssh identities
ssh-add -D

# kill agent
if [[ ! -z "$SSH_SHOULD_KILL_AGENT_ON_STOP" ]]; then
	eval `ssh-agent -k`
fi

exit 0
