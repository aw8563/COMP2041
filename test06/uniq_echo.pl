#!/usr/bin/perl

%map;

foreach (@ARGV) {
	if (!exists($map{$_})) {
		print "$_ ";
	}

	$map{$_} = "XD";
}

print("\n");

