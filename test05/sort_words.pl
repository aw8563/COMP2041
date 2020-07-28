#!/usr/bin/perl

my @lines = ();


while ($line = <>) {
	my @split = split (' ', $line); 
	
	my @sorted = sort(@split);
	
	foreach(@sorted) {
		print ("$_ ");
	}
	print ("\n");
}

