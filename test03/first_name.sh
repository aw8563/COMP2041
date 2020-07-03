#!/bin/bash

cat $1 | egrep "COMP[29]041" | cut -d "," -f2 | cut -d " " -f2 | sort | uniq -c | sort | sed "s/^ *//g" | cut -d " " -f2 | tail -n 1
