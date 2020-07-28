#!/bin/sh

courses=$(curl --silent "http://timetable.unsw.edu.au/2020/$1KENS.html")


# echo $courses | sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)$1" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary" | sort | uniq | sed "s/ $//g" | uniq

echo $courses | sed "s/<tr>/\n/g" | sed "s/<\/tr>/\n/g" | egrep "$1[0-9]{4}\.html" | sed "s/<\/td>/\n/g" | egrep "^ <td class=\"data\"><a" | sed "s/\.html//g" | sed "s/<\/a>//g" | cut -d "=" -f3 | sed "s/\"//g" | sed "s/>/ /g" | sort | uniq
