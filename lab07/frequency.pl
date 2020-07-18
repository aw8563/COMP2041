#!/usr/bin/perl

use File::Basename;

$target = $ARGV[0];
foreach $file (glob "lyrics/*.txt") {
	$basename = basename($file, ".txt");
	open(file, "<", "$file") or die $1;

	$basename =~ s/_/ /g;

	$total = 0;
	$count = 0;
	
	while (<file>) {
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


	close(file);
	printf("%4d/%6d = %.9f %s\n", $count, $total, $count/$total, $basename);
}