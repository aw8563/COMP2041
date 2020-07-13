#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	echo "shrug-rm: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"


force=0
cache=0


# check all files are actually in our index and we are allowed to remove them
for file in "$@"; do
	# set args
	if [ $file = "--force" ]; then
		force=1
		continue
	fi
	
	if [ $file = "--cached" ]; then
		cache=1
		continue
	fi

	# check file in index
	if [ ! -f "$path/index/$file" ]; then
		echo "shrug-rm: error: '$file' is not in the shrug repository"
		exit 1
	fi


	# Force remove will override everything
	if [ $force -ne 0 ]; then
		continue
	fi

	# if we do not have a copy of file in cwd, then it is always save to remove
	if [ ! -f "$file" ]; then
		continue
	fi

	# Make sure user doesn't lose work
	
	# This first check applies to even if --cached is set
	# if index is different to both cwd file and repo file
	if [ -f "$path/latest/$file" ] && \
		! (cmp -s "$file" "$path/index/$file") && \
		! (cmp -s "$path/index/$file" "$path/latest/$file"); then

		echo "shrug-rm: error: '$file' in index is different to both working file and repository"
		exit 1
	fi 


	# These checks apply ONLY when --cached is not set

	if [ $cache -eq 0 ]; then
		# If the repo file exists and is different to cwd file
		if [ -f "$path/latest/$file" ] && ! (cmp -s "$file" "$path/index/$file"); then
			echo "shrug-rm: error: '$file' in repository is different to working file"
			exit 1
		fi

		# If there are still staged changes not commited yet
		if [ -f "$path/staged/$file" ]; then
			echo "shrug-rm: error: '$file' has changes staged in the index"
			exit 1
		fi
	fi
done

for file in "$@"; do
	# skip args
	if [ $file = "--force" ] || [ $file = "--cached" ]; then
		continue
	fi

	mv "$path/index/$file" "$path/removed/" # move form index to removed folder so git status can display it
	rm -rf "$path/staged/$file"	# removed any staged changes

	# if we are force removing or --cached is not selected, we want to remove from cwd as well
	if [ $cache -eq 0 ]; then
		rm -rf "$file"
	fi
done
