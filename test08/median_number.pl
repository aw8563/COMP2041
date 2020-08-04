#!/usr/bin/perl -w


my @nums;

foreach (@ARGV) {
	push (@nums, $_);
}

@sorted = sort { $a <=> $b } @nums;


$len = @sorted;

if ($len%2 == 0) { #even
	print (($sorted[$len/2] + $sorted[$len/2 - 1])/2);
} else { # odd
	print ($sorted[($len - 1)/2]);
}

print "\n";
