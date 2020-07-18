#!/bin/dash

# some more advanced tests with shrug-rm
# user warning when work is about to be lost

. shrug-init

echo "hello" > a

. shrug-add a

. shrug-rm a # error, has staged changes
. shrug-rm --cached a # removed sucessfully

echo "world" > b

. shrug-add b
. shrug-commit -m "commit b"

echo "not saved" > b
. shrug-rm b # error, different to repo
. shrug-rm --cached b # removed succesfully

echo "1" > c
. shrug-add c
. shrug-commit -m "commit c"

echo "2" > c
. shrug-add c

echo "3" > c
. shrug-rm c # error, index different to cwd and repo
. shrug-rm --cached c # error, index different to cwd and repo
. shrug-rm --forced --cached # removed successfully from INDEX ONLY

# all will error since they are not in index
. shrug-rm --forced a  
. shrug-rm --forced b  
. shrug-rm --forced c   


. shrug-commit -m "commit removals"

. shrug-add a b c
. shrug-rm --forced a b c # remove with multiple arugments






