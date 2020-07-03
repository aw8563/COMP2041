#!/usr/bin/perl

my $start = $ARGV[0];
my $end = $ARGV[1];

my @range=($start..$end);

open (file, '>', $ARGV[2]) or die $!;
foreach (@range) {
	print file "$_\n";
}

close(file);
