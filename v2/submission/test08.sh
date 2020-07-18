#!/bin/dash

# testing shrug-branch and checkout

. shrug-init

. shrug-branch a
. shrug-branch b

. shrug-branch
# a
# b
# master

# delte branches
. shrug-branch -d a
. shrug-branch -d b 
. shrug-branch -d master # cannot delete branch we are on

. shrug-branch
# master


touch a


. shrug-branch branchA

# add files to master AFTER creating new branch
. shrug-add a
. shrug-commit -m "a"

touch b

. shrug-checkout branchA
ls # will only have b, since a was created and commited after new branch

touch c # file in branchA
echo "b" > b # change file in branchA

. shrug-add c
. shrug-commit -m "c"

. shrug-checkout master

ls # a and b but NOT c since it was created and commited in branch

. shrug-branch -d branchA # cannot delete because of unmerged changes


. shrug-branch branchB
. shrug-checkout branchB

# new file not in master
touch d

. shrug-add d
. shrug-commit -m "d"

echo "change" > d
. shrug-checkout master # error, need to commit changes

. shrug-commit -a -m "commit d"

. shrug-checkout master # success



