#!/bin/dash

# testing shrug-rm

# basic test cases where we make sure it's working

. shrug-init

echo "hello" > a

. shrug-add a
. shrug-commit -m "add a"

. shrug-show :a # "hello"

. shrug-rm a # removes a from index and cwd
. shrug-commit -m "remove a"

. shrug-show :a # error, not in index
cat a # error, no file found

echo "world" > b

. shrug-add b
. shrug-show :b # "world"

. shrug-rm --cached b
. shrug-commit -m "add b" # nothing to commit 
cat b # "world"

# both are already removed
. shrug-rm a # error, not in index
. shrug-rm b # error, not in index