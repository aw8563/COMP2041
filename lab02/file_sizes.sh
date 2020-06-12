#!/bin/sh

small="Small files:"                                                                                                    medium="Medium-sized files:"                                                                                            large="Large files:"   

for file in *; do
	
	count=$(wc -l $file | cut -f1 -d " ")

	if test $count -lt 10; then
		small="$small $file"
	elif test $count -lt 100; then
		medium="$medium $file"
	else
		large="$large $file"
	fi
done

echo $small
echo $medium
echo $large
