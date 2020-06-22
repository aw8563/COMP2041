#!/bin/bash

for file in *.jpg; do
	name="${file%%.*}"

	if test -f "${name}.png"; then
		echo "${name}.png already exists"
		exit 1
	fi
done


for file in *.jpg; do
	name="${file%%.*}"
	
	convert "${name}.jpg" "${name}.png"
	rm -rf "$file"
done
