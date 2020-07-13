#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"


force=0
cache=0


for arg in "$@"; do
	if [ $arg = "--force" ]; then
		force=1
	fi
	
	if [ $arg = "--cached" ]; then
		cache=1
	fi
done
