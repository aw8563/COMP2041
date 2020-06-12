while read numbers; do
	echo $numbers | tr "[1-4]" "<" | tr "[6-9]" ">"
done