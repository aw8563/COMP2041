#!/bin/dash


# check cwd is a repo
if [ ! -d ".shrug" ]; then
	# echo "Not a repository. Call shrug-init"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"

# commit number
n=$(wc -l $path/.commits | cut -d " " -f1)

msg=$2

# -a flag
if [ $1 = "-a" ]; then
	msg=$3

	# add all files from index
	for file in $path/index/*; do
		# TODO: remove delted files from index
		set -- $(basename $file) 
		. shrug-add
	done
fi

# search that we actually have a file to commit
if [ -z "$(ls $path/staged)" ]; then
	echo "nothing to commit"
	exit 1
fi

# commit everything that is tracked
echo "$n $msg" >> "$path/.commits"
echo "Committed as commit $n"

# create commit directory
mkdir "$path/$n"
for file in $path/index/*; do
	# copy to commits folder
	cp "$file" "$path/$n/"

	# update our latest changes
	cp "$file" "$path/latest/"	
done

# clean staged files
rm -rf "$path/staged/"
mkdir "$path/staged/"
