#!/bin/dash
if [ ! -d ".shrug" ]; then
	echo "shrug-status: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"

rm -rf .dummy
mkdir .dummy

# add all files in cwd/index/removed so we output deleted files in alphabetical order...
for file in $path/removed/*; do
	# skip non files
	if [ ! -f "$file" ]; then
		continue
	fi

	cp $file .dummy/
done

for file in $path/index/*; do
	# skip non files
	if [ ! -f "$file" ]; then
		continue
	fi

	cp $file .dummy/
done

for file in *; do
	# skip non files
	if [ ! -f "$file" ]; then
		continue
	fi

	cp $file .dummy/
done


for dummyfile in .dummy/*; do
	if [ ! -f "$dummyfile" ]; then
		continue
	fi

	file=$(basename $dummyfile)

	# check if the file was shrug-rm'ed
	if [ -f "$path/removed/$file" ]; then
		# if we are checking a removed file,
		if [ -f "$file" ]; then
			echo "$file - untracked"
		else
			echo "$file - deleted"
		fi
		continue
	fi

	# if the file is missing, then it has been deleted by user
	if [ ! -f "$file" ]; then
		if [ -f "$path/staged/$file" ]; then
			echo "$file - added to index, file deleted"
		else
			echo "$file - file deleted"
		fi

		continue
	fi

	# FILE HAS NOT BEEN REMOVED
	# check if we are tracking it in our index
	if [ ! -f "$path/index/$file" ]; then

		echo "$file - untracked"
		continue
	fi

	# FILE IS IN OUR INDEX
	# check if there are previous commits
	if [ ! -f "$path/latest/$file" ]; then
		if [ -f "$path/staged/$file" ] && !(cmp -s "$file" "$path/staged/$file" ); then
			echo "$file - added to index, file changed"
		else
			echo "$file - added to index"
		fi

		continue
	fi

	# FILE HAS PREVIOUS COMMITS
	# check if there are already changes staged
	if [ -f "$path/staged/$file" ]; then
		# check if EXTRA changes have been made but not staged
        if cmp -s "$file" "$path/staged/$file"; then
        	echo "$file - file changed, changes staged for commit"
        else
        	echo "$file - file changed, different changes staged for commit"
        fi

        continue
	fi

	# FILE HAS NO STAGED CHANGES AND HAS PREVIOUS COMMITS
	# check if there are changes that will cause it to be different to repo
	if cmp -s "$file" "$path/latest/$file"; then
		echo "$file - same as repo"
	else
		echo "$file - file changed, changes not staged for commit"
	fi
done

rm -rf .dummy