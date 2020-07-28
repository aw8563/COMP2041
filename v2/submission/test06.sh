#!/bin/dash

# more shrug-rm tests. 

# test we can shrug-add to undo a shrug-rm
# shrug-rm first stages the removal. We still need to commit it before the file is actually removed

# test shrug-rm works when we delete the local file ourselves 

. shrug-init

touch a 
. shrug-add a

. shrug-commit -m "commit a"
rm a # "removes a"
cat a # file doesn't exist

. shrug-add a # stages a removal of a
. shrug-commit -m "removing a"

. shrug-add a # error, file doens't exist

touch b
. shrug-add b
. shrug-commit "add b"

echo "changed" > b
. shrug-add b

rm b # remove locally
. shrug-rm b # always works when we don't have a local file

. shrug-commit -m "repo is empty now"

# both not in index
. shrug-show :a
. shrug-show :b
