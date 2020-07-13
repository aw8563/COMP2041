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
	cp $file .dummy/
done

for file in $path/index/*; do
	cp $file .dummy/
done

for file in *; do
	# skip directories
	if [ -d "$file" ]; then
		continue
	fi

	cp $file .dummy/
done

for dummyfile in .dummy/*; do
	file=$(basename $dummyfile)

	# check that the file has not been deleted in cwd
	if [ ! -f "$file" ]; then
		echo "$file - file deleted"
		continue
	fi

	# not in index
	if [ ! -f "$path/index/$file" ]; then
		# check whether the file is untracked or was removed from index
		if [ -f "$path/latest/$file" ]; then
			echo "$file - deleted"
		else
			echo "$file - untracked"
		fi

		continue
	fi

	# FILE IS IN OUR INDEX

	# if there are already changes staged
	if [ -f "$path/staged/$file" ]; then
		# check if EXTRA changes have been made but not staged
        if cmp -s "$file" "$path/staged/$file"; then
        	echo "$file - file changed, changes staged for commit"
        else
        	echo "$file - file changed, different changes staged for commit"
        fi

        continue
	fi

	# FILE IS IN OUR INDEX BUT NO STAGED CHANGES

	# check if it has just been added	
	if [ ! -f "$path/latest/$file" ]; then
		echo "$file - added to index"
		continue
	fi

	# FILE IS IN OUR INDEX AND HAS PREVIOUS COMMIT

	# check if there are changes that have not been staged
	if cmp -s "$file" "$path/latest/$file"; then
		echo "$file - same as repo"
	else
		echo "$file - file changed, changes not staged for commit"
	fi
done

rm -rf .dummy