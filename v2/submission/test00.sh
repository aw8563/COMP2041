#!/bin/dash

# basic test cases 

touch a b c

# first test all the scripts do not work without an initial repo
. shrug-add a b c 
. shrug-commit -m "test"
. shrug-log
. shrug-show :a
. shrug-rm a b c
. shrug-status
. shrug-branch
. shrug-checkout "test"
. shrug-merge "test"

# Test shrug-init
. shrug-init

# Cannot run it again since .shrug direcotry exists
. shrug-init

rm -rf .shrug

# Test we cannot shrug-init with a file called .shrug existing
touch .shrug
. shrug-init

