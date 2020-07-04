#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/_branch)"

arg=$1

commit=$(echo $arg | cut -d ":" -f1)
file=$(echo $arg | cut -d ":" -f2)

n=$(wc -l $path/_commits | cut -d " " -f1)

# if commit is not provided, take the current staged file
if [ -z "$commit" ]; then
	if [ ! -d $path/$file ] || [ ! -f $path/$file/_tracked ]; then
        	echo "shrug-show: error: '$file' not found in index"
        	exit 1
	fi



	if [ -f "$path/$file/staged" ]; then
		cat "$path/$file/staged"
	else
		cat "$path/$file/latest"
	fi
else # use the commit index instead

	# if commit does not exist
	if [ $commit -gt $n ]; then
        	echo "shrug-show: error: unknown commit '$commit'"
        	exit 1
	fi

	# file not present in that commit
	if [ ! -f "$path/$file/$commit.$file" ]; then
		echo "shrug-show: error: '$file' not found in commit $commit"
		exit 1	
	fi

	cat "$path/$file/$commit.$file"
fi
