#!/bin/dash

if [ ! -d ".shrug" ]; then
	echo "shrug-branch: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

currentBranch=$(cat .shrug/.branch)

# list branches
if [ $# -eq 0 ]; then

	ls -d .shrug/*/ | cut -d "/" -f2 | cat 
	exit 0
fi

# deleting branch
if [ $1 = "-d" ]; then
	branch=$2

	if [ -z $branch ]; then
		echo "Please specifiy branch to delete"
		exit 1
	fi

	if [ $currentBranch = $branch ]; then
		echo "Cannot delete branch you are currently on";
		exit 1
	fi

	if [ ! -d ".shrug/$branch/" ]; then
		echo "shrug-branch: error: branch '$branch' does not exist"
		exit 1
	fi

	echo "Deleted branch '$branch'"
	rm -rf ".shrug/$branch"
	exit 0
fi




mkdir ".shrug/$1"
touch .shrug/.commits
mkdir ".shrug/$1/index"
mkdir ".shrug/$1/latest"
mkdir ".shrug/$1/staged"
mkdir ".shrug/$1/removed"

# our first master branch does not need to perform these copies
if [ $1 != "master" ]; then
	# copy index from our upstream branch
	cp -R ".shrug/$currentBranch/index" ".shrug/$1/"
	cp -R ".shrug/$currentBranch/latest" ".shrug/$1/"
fi




