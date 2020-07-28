#!/bin/sh

. snapshot-save.sh


version=$1

echo "Restoring snapshot $version"

for file in .snapshot.$version/*; do
	if [ ! -f $file ]; then
		continue;
	fi

	if [ $file = "snapshot-load.sh" ] || [ $file = "snapshot-save.sh" ]; then
		continue;
	fi

	cp $file . 
done



