#!/bin/dash

# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/_branch)"


force=0
cache=0


for arg in "$@"; do
	if [ $arg = "--force" ]; then
		force=1
	fi
	
	if [ $arg = "--cached" ]; then
		cache=1
	fi
	
	# only check tracked files
	if [ ! -f $path/$arg/_tracked ]; then
		continue
	fi

        # force remove file no matter what
        if [ $force -ne 0 ]; then
                rm -rf $path/$arg/_tracked
                rm -rf $path/$arg/staged
		rm -rf $arg
		continue
        fi
	
	# remove from index if file doesn't exist or --cached flag
	if [ ! -f $arg ] || [ $cache -ne 0 ]; then
		rm -rf $path/$arg/_tracked
		continue
	fi

	# otherwise check we won't lose work by removing
	
	# first check there are no STAGED changes
	if [ -f $path/$arg/staged ]; then
		continue
	fi

	# then check that the file is up to date with LATEST commit
	if [ -f $path/$arg/latest ]; then
		if ! cmp -s $path/$arg/latest "$arg"; then
			continue
		fi
	fi
	
	# remove 
	rm -rf $path/$arg/_tracked
	rm -rf $arg
done
