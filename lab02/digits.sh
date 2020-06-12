#!/bin/sh
while read numbers; do
	echo $numbers | tr "[0-4]" "<" | tr "[6-9]" ">"
done
