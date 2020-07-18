#!/usr/bin/perl

use File::Basename;

# get all the words we care about first

%wordFrequency; # [artist][word]

foreach $file (glob "lyrics/*.txt") {


	$basename = basename($file, ".txt");
	$basename =~ s/_/ /g;


	open(file, "<", "$file") or die $1;


	$total = 0;
	
	while (<file>) {
		chomp;
		my @words = split("[^a-zA-Z]", $_);

		foreach (@words) {
			$word = lc("$_");

			if ($word eq "") {
				next;
			}			

			$wordFrequency{$basename}{$word} += 1;	
			$total++;
		}
	}

	$wordFrequency{$basename}{"_total"} = $total;


	close(file);
}


foreach $song (@ARGV) {
	open(file, "<", "$song") or die $1;
	
	my %probabilities;

	while (<file>) {
		chomp;
		my @words = split("[^a-zA-Z]", $_);
		foreach (@words) {
			$word = lc("$_");

			if ($word eq "") {
				next;
			}

			foreach $artist (keys %wordFrequency) {
				# loop through artist
				$probability = ($wordFrequency{$artist}{$word} + 1)/$wordFrequency{$artist}{"_total"};
				$probabilities{$artist} += log($probability);
			}
		}
	}

	my $max;
	my $maxArtist;
	foreach $artist (keys %probabilities) {
		$p = $probabilities{$artist};
		if (!defined $max or $p > $max) {
			$max = $p;
			$maxArtist = $artist;
		}
	}

	printf("$song most resembles the work of $maxArtist (log-probability=%.1f)\n", $max);
	close(file);
}