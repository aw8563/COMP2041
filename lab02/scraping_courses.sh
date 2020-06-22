#!/bin/sh

undergraduate=$(curl --silent "http://legacy.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=All")
postgraduate=$(curl --silent "http://legacy.handbook.unsw.edu.au/vbook2018/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=All")

courses="$undergraduate <TD class=\"\">$postgraduate"

echo $courses | sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)$1" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary" | sort | uniq | sed "s/ $//g" | uniq

echo $undergraduate > undergraduate
echo $postgraduate > postgraduate


# sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)MATH" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[>]//g" | sed "s/<\/A//g" | sed "s/^\///g" | sed "s/\.html\"/ /g" | grep -v "glossary"

# sed "s/<TD class=\"\">/\n/g" | sed "s/<TD class=\"\" align=\"left\">/\n/g" | egrep "( |>|/)MATH" | egrep -o "/[^/]*\.html\">.*</A>" | cut -d ">" -f1,2 | sed "s/[/>]//g" | sed "s/<A//g" | sed "s/\.html\"/ /g"
