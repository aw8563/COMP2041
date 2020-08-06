#!/bin/dash
for word1 in Houston 1202 alarm
do
	for word2 in Houston 1202 alarm
	do
		if test -d /dev/null
		then
		    echo /dev/null
		else
		   echo /dev
		fi
		# XDDDDDDDDDD
		if test -d /dev/null
		then
		    echo /dev/null
		elif test -r /dev/nulls
		then
		    echo a
		else 
			echo $word1 -- $word2
		fi
	done
done

ls 