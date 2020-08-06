#!/bin/dash

file=$1
if [ -z $1 ]; then
	if [ ! -f "test.sh" ]; then
		echo "please specify file"
		exit 1
	else
		file="test.sh"
	fi
fi

if [ ! -f "$file" ]; then
	echo "'$file' doesn't exist"
	exit 1
fi


rm -rf out.pl
echo "RUNNING ON FILE '$file'"
echo "============================"
./sheeple.pl $file
echo 
echo "============================"
cat out.pl
echo 
echo "============================"

./out.pl