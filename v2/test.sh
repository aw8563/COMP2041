#!/bin/sh

echo 1 >a
echo 2 >b
echo 3 >c
./shrug-add.sh a b c
./shrug-commit.sh -m "first commit"

echo 4 >>a
echo 5 >>b
echo 6 >>c
echo 7 >d
echo 8 >e
./shrug-add.sh b c d
echo 9 >b
