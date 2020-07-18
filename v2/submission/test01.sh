#!/bin/dash

# simple test with add and commit

. shrug-init

echo 1 > a
echo 2 > b
echo 3 > c


# a b in index but not c
. shrug-add a b

.shrug commit -m "commit 0"

echo hello > a
echo world > b

# add changes to a
. shrug-add a

# commit changes to ONLY a and not b
. shrug-commit -m "commit 1"

. shrug-show :a # "hello"
. shrug-show :b # "2"
. shrug-show :c # not in index
. shrug-show 0:a # 1

. shrug-add d # file doesn't exist

. shrug-log 
# 1 commit 1
# 0 commit 0