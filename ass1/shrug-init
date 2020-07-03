#!/bin/dash

# check direcotry .shrug
if [ -d ".shrug" ]; then
	echo "shrug-init: error: .shrug already exists"
	exit 1
fi

# check file .shrug
if [ -f ".shrug" ]; then
	echo "shrug-init: error: .shrug already exists"
	exit 1
fi

# initialise new repo
echo "Initialized empty shrug repository in .shrug"
mkdir ".shrug"
echo "master" > ".shrug/_branch"

mkdir ".shrug/master"
touch ".shrug/master/_commits"