#!/bin/sh

version=0;

while true; do
	if [ ! -d .snapshot.$version ]; then
		break;	
	fi	
 
	version=$((version + 1))
done

echo "Creating snapshot $version"
mkdir .snapshot.$version

for file in *; do
	if [ ! -f $file ]; then 
		continue;	
	fi
	
	if [ $file = "snapshot-save.sh" ] || [ $file = "snapshot-load.sh" ]; then
		continue;
	fi	

	cp $file .snapshot.$version/
done


