#!/bin/dash
i="0"
while test $i -lt 5
do
    echo $i
    i=`expr $i + 1`  # increment number
done