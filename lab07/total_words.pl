#!/usr/bin/perl

$count = 0;

while (<>) {
	chomp;


	my @words = split("[^a-zA-Z]", $_);

	foreach (@words) {
		if ($_ ne "") {
			$count++;
		}
	}
}

print ("$count\n");