#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"

tac $path/.commits