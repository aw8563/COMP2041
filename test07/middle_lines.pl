#!/usr/bin/perl

open (file, "<", "$ARGV[0]") or die $!;

my @lines;

while ($line = <file>) {
	push(@lines, $line);
}

$len = @lines;

if ($len % 2 == 1) {
	print (@lines[($len-1)/2]);

} else {
	print (@lines[$len/2 - 1]);
	print (@lines[$len/2]);
}


