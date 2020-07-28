#!/bin/sh

file=$1
version=0;

while true; do
	if [ ! -f .$file.$version ]; then
		cp "$file" ".$file.$version";
		
		echo "Backup of '$file' saved as '.$file.$version'"
		break;
	fi
	
	version=$((version + 1))
done	
