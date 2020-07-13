#!/bin/dash

# check if .shrug exists already
if [ -d ".shrug" ] || [ -f ".shrug" ]; then
	echo "shrug-init: error: .shrug already exists"
	exit 1
fi


# initialise new repo
echo "Initialized empty shrug repository in .shrug"
mkdir ".shrug"
echo "master" > ".shrug/.branch"

./shrug-branch.sh "master"
