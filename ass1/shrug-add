#!/bin/dash
if [ ! -d ".shrug" ]; then
	echo "shrug-add: error: no .shrug directory containing shrug repository exists"
	exit 1
fi
path=".shrug/$(cat .shrug/_branch)"



for file in "$@"; do
	# if the file doesn't exist in current directory, ignore it
	if [ ! -f "$file" ]; then
		echo "shrug-add: error: can not open '$file'"
		continue
	fi


	# if we are already tracking this file, do not create new direcotry for it
	if [ ! -d "$path/$file" ]; then
		mkdir "$path/$file"
	fi

	# if there is no change to the file, do not add it	
    if [ -f "$path/$file/latest" ]; then
        if cmp -s "$file" "$path/$file/latest"; then
                continue
        fi
    fi

	# update latest changes
	cp "$file" "$path/$file/staged"
	touch "$path/$file/_tracked"
done

