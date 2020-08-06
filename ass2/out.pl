#!/usr/bin/perl -w
foreach $word1 ('Houston', '1202', 'alarm') {
	foreach $word2 ('Houston', '1202', 'alarm') {
		if (-d '/dev/null') {
		    print "/dev/null\n";
		} else {
		   print "/dev\n";
		}
		# XDDDDDDDDDD
		if (-d '/dev/null') {
		    print "/dev/null\n";
		} elsif (-r '/dev/nulls') {
		    print "a\n";
		} else {
			print "$word1 -- $word2\n";
		}
	}
}

system "ls ";
