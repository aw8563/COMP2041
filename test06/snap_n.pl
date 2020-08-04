#!/usr/bin/perl

$limit = $ARGV[0];

%map;

while (<STDIN>) {
	$map{$_} ++;
	if ($map{$_} >= $limit) {
		print ("Snap: $_");
		exit 0;
	}
}
