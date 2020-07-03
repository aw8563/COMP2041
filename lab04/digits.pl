#!/usr/bin/perl
while ($line = <>) {
	$line =~ s/[0-4]/</g;
	$line =~ s/[6-9]/>/g;
	print $line

}

