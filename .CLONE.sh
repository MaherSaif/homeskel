#!/bin/sh

[ -z "$1" ] && echo "Arg required: url from which should I clone" && exit 1

[ -z "`which git`" ] && echo "Install git first" && exit 1
[ -z "`which screen`" ] && echo "Install screen first" && exit 1

cd

[ -f ".bashrc" ] && mv ".bashrc" ".bashrc.local"
[ -f ".bash_profile" ] && mv ".bash_profile" ".bash_profile.local"
[ -f ".CLONE.sh" ] && mv ".CLONE.sh" "CLONE.sh"

git init
git remote add origin "$1"
git fetch
git branch master origin/master
git checkout master
git submodule init
git submodule update

exit 0
