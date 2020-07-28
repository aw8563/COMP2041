#!/usr/bin/perl


use File::Compare;

foreach (@ARGV) {
	if (compare("$ARGV[0]", "$_") != 0) {
		print ("$_ is not identical\n");
		exit 1;
	}
}

print ("All files are identical\n");
