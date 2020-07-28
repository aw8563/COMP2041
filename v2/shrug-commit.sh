#!/bin/dash


# check cwd is a repo
if [ ! -d ".shrug" ]; then
	echo "shrug-commit: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"

# commit number
n=$(wc -l .shrug/.commits | cut -d " " -f1)

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
if [ -z "$(ls $path/staged)" ] && [ -z "$(ls $path/removed)" ]; then
	echo "nothing to commit"
	exit 1
fi

# commit everything that is tracked
echo "$n $msg" >> ".shrug/.commits"
echo "Committed as commit $n"

rm -rf "$path/latest/"
mkdir "$path/latest"

# create commit directory
mkdir "$path/$n"
for file in $path/index/*; do
	if [ ! -f $file ]; then
		continue
	fi

	# copy to commits folder
	cp "$file" "$path/$n/"

	# update our latest changes
	cp "$file" "$path/latest/"	
done

# clean staged/removed files
rm -rf "$path/staged/"
mkdir "$path/staged/"

rm -rf "$path/removed"
mkdir "$path/removed"
