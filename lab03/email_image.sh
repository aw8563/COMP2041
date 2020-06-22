#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Please provide image name(s) in arguments"
	exit 1
fi

for file in "$@"; do
	echo $file
	display "$file"
	
	echo -n "Address to e-mail this image to? "
	read email
	
	if [[ -z $email ]]; then
		continue
	fi

	echo -n "Message to accompany image? "
	read message

	
	echo "$message" | mutt -a $file -- $email
done



