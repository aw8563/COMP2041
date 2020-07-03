#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	echo "Not a repository. Call shrug-init"
	exit 1
fi

# check arguments
branch=$1
if [ -z $branch ]; then
	echo "Please specify branch name"
	exit 1
fi

# check branch exists
if [ ! -d ".shrug/$branch/" ]; then
	echo "Branch does not exist"
	exit 1
fi

# checkout to new branch
echo "$branch" > ".shrug/_branch"
echo "Switched to branch '$branch'"