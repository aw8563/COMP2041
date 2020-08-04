#!/bin/sh

for file1 in $1/*; do
	for file2 in $2/*; do

		if [ ! -f "$file1" ] || [ ! -f "$file2" ]; then
			continue;
		fi
		
		base1=$(basename "$file1")		
		base2=$(basename "$file2")
			

		if [ "$base1" = "$base2" ] && (cmp -s "$file1" "$file2" ); then
			echo "$base1";
		fi

		
	done
done
