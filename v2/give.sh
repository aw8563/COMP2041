#!/bin/sh

rm -rf final
mkdir final
for file in shrug-*.sh; do
	cp $file final/"${file%.*}"
done
