#!/usr/bin/perl


open(file, "<", "$ARGV[0]") or die $!;

@lines;


while ($line = <file> ) {
	push(@lines, $line);	
}

@sorted = sort {length $a <=> length $b or $a cmp $b } @lines;

print (@sorted);

