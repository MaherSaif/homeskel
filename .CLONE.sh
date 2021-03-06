#!/bin/sh


if [ -z "$1" ]; then
	echo "No argument given - using the default"
	URL="git@github.com:`whoami`/homeskel.git"
else
	URL="$1"
fi

echo "Cloning from: $URL"

[ -z "`which git`" ] && echo "Install git first" && exit 1
[ -z "`which screen`" ] && echo "Install screen first" && exit 1

cd

if [ ! -d ".git" ]; then
	git init
	git remote add origin "$URL"
	git fetch
fi

git branch master origin/master
git checkout master
git submodule init
git submodule update

exit 0
