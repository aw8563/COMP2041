#!/bin/dash


if [ ! -d ".shrug" ]; then
	echo "Not a repository. Call shrug-init"
	exit 1
fi

currentBranch=$(cat .shrug/_branch)

# list branches
if [ $# -eq 0 ]; then

	ls -d .shrug/*/ | cut -d "/" -f2 | cat 
	echo "Currently on '$currentBranch'"

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
		echo "Branch '$branch' does not exist"
		exit 1
	fi

	echo "Removed branch '$branch'"
	rm -rf ".shrug/$branch"
	exit 0
fi

# create new branch
echo "New branch '$1' created"
mkdir ".shrug/$1"
touch shrug/$1/_commits



