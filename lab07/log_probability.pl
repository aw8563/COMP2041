#!/usr/bin/perl

use File::Basename;

$target = $ARGV[0];
foreach $file (glob "lyrics/*.txt") {
	$basename = basename($file, ".txt");
	open(f, "<", "$file") or die $1;

	$basename =~ s/_/ /g;

	$total = 0;
	$count = 0;
	
	while (<f>) {
		chomp;
		my @words = split("[^a-zA-Z]", $_);

		foreach (@words) {
			if (lc("$_") eq $target) {
				$count++;
			}
			if ($_ ne "") {
				$total++;
			}
		}
	}


	close(f);
	printf("log((%d+1)/%6d) = %8.4f %s\n", $count, $total, log(($count + 1)/$total), $basename);
}
