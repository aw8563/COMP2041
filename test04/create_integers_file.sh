#!/bin/sh

for ((i=$1;i<=$2;i++)); do
	echo $i >> $3
done;
