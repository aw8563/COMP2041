#!/bin/dash

# test shrug-commit with no changes

. shrug-init

echo "hello" > a
. shrug-add a
. shrug-commit -m "a" # first commit

. shrug-add a
. shrug-commit -m "a" # nothing to commit

echo "world" > a
. shrug-add a # a has contents "world" in index

echo "hello" > a 
. shrug-add a # a now has contents "hello" in index
. shrug-commit # nothing to commit (same as repo)

. shrug-show 0:a # hello
. shrug-show 1:a # commit doesn't exist

. shrug-show :a # hello

echo "no commit but still shows" > bin
. shrug-show :b # error, file doesn't exist
. shrug-show 0:b # error, file not found in commit

. shrug-add b
. shrug-show :b # "no commit but still shows"
