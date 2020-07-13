#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"

arg=$1

commit=$(echo $arg | cut -d ":" -f1)
file=$(echo $arg | cut -d ":" -f2)

nCommits=$(wc -l $path/.commits | cut -d " " -f1)

# if commit is not provided, take the current staged file
if [ -z "$commit" ]; then
	if [ ! -f "$path/index/$file" ]; then
    	echo "shrug-show: error: '$file' not found in index"
    	exit 1
	fi

	cat "$path/index/$file"
else # use the commit index instead
	# if commit does not exist
	if [ $commit -ge $nCommits ]; then
    	echo "shrug-show: error: unknown commit '$commit'"
    	exit 1
	fi

	# file not present in that commit
	if [ ! -f "$path/$commit/$file" ]; then
		echo "shrug-show: error: '$file' not found in commit $commit"
		exit 1	
	fi

	cat "$path/$commit/$file"
fi
