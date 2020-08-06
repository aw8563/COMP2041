#!/bin/dash
# print a contiguous integer sequence
start=$1
finish=$2

number=$start
while test $number -le $finish
do
    echo $number
    number=`expr $number + 1`
done

if test -r nonexistantfile
then
    echo b
fi