#!/bin/dash

# testing subset1
# shrug-add with -a flag

. shrug-init

touch a b c 

# c not added
. shrug-add a b 

echo "hello" > a
echo "world" > b
echo "empty" > c

. shrug-commit -m "not added yet" # no changes to commit

. shrug-add a
. shrug-commit -a -m "all files in index" # commits both a and b but not c

. shrug-show :a # "hello"
. shrug-show :b # "world"
. shrug-show :c # error, not in index

rm -rf a b

echo "hello" > a
echo "world" > b

. shrug-commit -a -m "no change" # no changes to commit
