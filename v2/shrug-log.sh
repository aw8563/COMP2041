#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	echo "shrug-log: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

tac ".shrug/.commits"
exit 1

path=".shrug/$(cat .shrug/.branch)"

tac $path/.commits