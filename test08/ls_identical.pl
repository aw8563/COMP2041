#!/usr/bin/perl -w

use File::Basename;
use File::Compare;

foreach $file1 (glob "$ARGV[0]/*") {
	foreach $file2 (glob "$ARGV[1]/*") {
		$base1 = basename("$file1");
		$base2 = basename("$file2");
	
		if ("$base1" eq "$base2" && compare("$file1", "$file2") == 0) {
			print ("$base1", "\n");
		} 	
	}
}
