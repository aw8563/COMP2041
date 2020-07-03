#!/usr/bin/perl

if ($#ARGV != 1) {
	print ("Usage: ./echon.pl <number of lines> <string>", "\n");
	exit 1;
}


if ("$ARGV[0]" !~ /^[0-9]*$/) {
	print ("./echon.pl: argument 1 must be a non-negative integer\n");
	exit 1;
}


my @i = (1..$ARGV[0]);


for (@i) {
	print($ARGV[1], "\n");
}
