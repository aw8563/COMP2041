#!/bin/dash
if [ ! -d ".shrug" ]; then
	echo "shrug-add: error: no .shrug directory containing shrug repository exists"
	exit 1
fi

path=".shrug/$(cat .shrug/.branch)"



for file in "$@"; do
	# if the file doesn't exist in current directory, ignore it
	if [ ! -f "$file" ] && [ ! -f "$path/index/$file" ]; then
		echo "shrug-add: error: can not open '$file'"
		exit 1
	fi
done

for file in "$@"; do
	# adding a 'rmed' file to the removed index
	if [ ! -f "$file" ]; then
		mv "$path/index/$file" "$path/removed/"
		continue
	fi


	# update index
	cp "$file" "$path/index/"

	# add to staged only if it is different to our previous committed file
	if [ -f "$path/latest/$file" ] && cmp -s "$file" "$path/latest/$file"; then
		rm -f "$path/staged/$file"
	else 
		cp "$file" "$path/staged" 
	fi
done
