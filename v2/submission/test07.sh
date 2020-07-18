#!/bin/dash

# Test shrug-status

# lots of different conditions
. shrug-init


# test correct output for tracked files that have changed
touch a b c

. shrug-add a b c
. shrug-commit -m "commit a b c"

echo "change" > a
echo "change" > b
echo "change" > c

. shrug-add a b 

echo "another change" > a

. shrug-status
# a - changed, different changes staged
# b - changes staged
# c - changes not staged


rm -rf *
rm -rf .shrug

. shrug-init

# test untracked and unchagned files
touch a b c

. shrug-add a

. shrug-commit -m "commit a"

. shrug-add b

. shrug-status
# a - same as repo
# b - added to index
# c - untracked


rm -rf *
rm -rf .shrug

. shrug-init

# test deleted and rm'ed files
touch a b c 
. shrug-add a b 
. shrug-commit -m "commit a b"

. shrug-rm a

rm b

. shrug-status
# a - deleted (from index)
# b - file deleted (locally)
# c - untracked

. shrug-commit -m "removed a"
. shrug-rm a # error, not in index

rm -rf *
rm -rf .shrug

# testing the new spec changes

. shrug-init

touch a b c 
. shrug-add a b 
. shrug-commit -m "commit a b"

rm b
. shrug-add a b c

echo "change" > a

. shrug-status
# a - added to index, changed
# b - added to index, removed
# c - added to index