#!/bin/dash


# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/_branch)"

msg=$2
found=0

# -a flag
if [ $1 = "-a" ]; then
	msg=$3

	# we want to stage all added files

	for file in $(ls $path/ | cat); do
		if [ -f $path/$file ]; then
			continue
		fi
		
		
		set -- $file		
		. shrug-add 
	done
fi

if [ -z "$msg" ]; then
	echo "Please specify commit message"
	exit 1
fi

# commit number
n=$(wc -l $path/_commits | cut -d " " -f1)



for file in $(ls $path/ | cat); do

	# only consider directories
	if [ -f $path/$file ]; then
		continue
	fi

	# search if we have a file that's been staged for commit
	if [ -f $path/$file/staged ]; then
		found=1
		break
	fi
done


# only commit if we have changes
if [ $found -ne 0 ]; then
	echo "$n $msg" >> $path/_commits
	echo "Committed as commit $n"
        
	for file in $(ls $path/ | cat); do

        # only consider directories
        if [ -f $path/$file ]; then
                continue
        fi

        # Only consider files that are tracked.
        # If the file is shrug-rm'ed we ignore it. 
        if [ ! -f $path/$file/_tracked ]; then
        	continue
        fi

        # changes have been STAGED for commit via shrug-add
		if [ -f $path/$file/latest ]; then
			cp $path/$file/latest $path/$file/$n.$file		
		fi

		if [ -f $path/$file/staged ]; then
	        # create backup
	        cp $path/$file/staged $path/$file/$n.$file
	        mv $path/$file/staged $path/$file/latest
		fi
		
	done
else
	echo "nothing to commit"
fi
