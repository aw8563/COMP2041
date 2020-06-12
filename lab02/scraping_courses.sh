#!/bin/sh

undergraduate=$(curl --silent "http://legacy.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=All")
postgraduate=$(curl --silent "http://legacy.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=All")

# echo $undergraduate > undergraduate
# echo $postgraduate > postgraduate


echo $undergraduate | sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)$1" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary"
echo $postgraduate | sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)$1" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary"

# sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)MATH" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary"

# sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)MATH" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[/>]//g" | sed "s/<A//g" | sed "s/\.html\"/ /g"