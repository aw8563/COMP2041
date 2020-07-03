#!/bin/bash


for file in "$@"; do
	for f in $(cat $file | egrep "#include \"" | egrep -o "\".*\"" | sed "s/\"//g"); do
		if test ! -f $f; then
			echo "$f included into $file does not exist"
		fi			
	done
done


