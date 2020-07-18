#!/usr/bin/perl

use File::Copy;
use File::Basename;

$v = 0;

while (1) {
	if ( ! -d ".snapshot.$v") {
		last;
	}
	
	$v++;
}
mkdir ".snapshot.$v";
my @dir = <"*">;


foreach my $file (@dir) {
	if ("$file" ne "snapshot.pl") {
		copy($file, ".snapshot.$v/$file");
	}
}


if ($ARGV[0] eq "load") {
	$v = $ARGV[1];
	
	my @snapshot = <".snapshot.$v/*">;
	foreach my $file (@snapshot) {
		($base, $_, $_) = fileparse($file);
	
		copy("$file", "./$base");
	}
}

