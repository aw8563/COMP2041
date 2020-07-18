#!/bin/dash

# testing shrug-merge

# simple case

. shrug-init
seq 10 > a

. shrug-add a
. shrug-commit -m "a"

. shrug-branch branchA

. shrug-checkout branchA

sed -i 's/1/ONE/g' a
echo 11 >> a

touch b
touch c

. shrug-add b

. shrug-add -a -m "commit a b"

. shrug-checkout master

cat a # 1 .. 10. Does not include changes from branchA

ls # a, c. does not include commited file b from branchB but does include uncommited c


sed -i 's/2/TWO/g' a

. git-merge b # merge changes FROM b INTO master

ls # a, b, c. Merged file b

cat a
# ONE
# TWO
# 3
# ...
# 10
# 11 


rm -rf *
rm -rf .shrug
. shrug-init

# TEST MERGE CONFLICTS

seq 10 > a
. shrug-add a
. shrug-commit -m "a"

. shrug-branch branchB

. shrug-commit -a -m "ONE"

. shrug-checkout branchB
sed -i 's/1/one/g' a
sed -i 's/2/two/g' a

. shrug-commit -a -m "one, two"

. shrug-checkout master

. shrug-merge branchB # conflict

sed -i 's/1/one/g' a
. shrug-commit -a -m "one"

. shrug-merge branchB # no conflict

cat a
# one
# two
# 3
# ...
# 10