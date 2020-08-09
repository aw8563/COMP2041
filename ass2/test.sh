#!/bin/dash

while [ 1 ]
do
        read line
        echo $line

        if test $line = q
        then
                echo "FINISH"
                exit
        elif test $line = "JKLDSJFLKSJDFKL"
        then
                echo "????"
        else
                echo "q to quit"
        fi
done               