#!/usr/bin/perl

open(file, '<', $ARGV[1]) or die $!;

my $n = $ARGV[0];
my $i = 0;

while ($line = <file>) {
	$i ++;
	if ($i == $n) {
		print ($line);
	}
}
