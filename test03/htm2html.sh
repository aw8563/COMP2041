#!/bin/bash

for file in *.htm; do
	name="${file%%.*}"
	
	
	if test -f ${name}.html; then
		echo "${name}.html exists"	
		exit 1
	fi
done

for file in *.htm; do
	name="${file%%.*}"
	mv ${name}.htm ${name}.html
done



