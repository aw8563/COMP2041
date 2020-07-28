#!/usr/bin/perl

$count = 0;

$target = lc("$ARGV[0]");

while (<STDIN>) {
	chomp;
	my @words = split("[^a-zA-Z]", $_);

	foreach (@words) {
		if (lc("$_") eq $target) {
			$count++;
		}
	}
}

print ("$ARGV[0] occurred $count times\n");
