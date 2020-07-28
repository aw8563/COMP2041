#!/usr/bin/perl


open (F, '<', $ARGV[0]) or die $!;


my @lines = ();

while (my $line = <F>) {
	$line =~ s/[0-9]/#/g;

	push(@lines, $line);
}


open (F, '>', $ARGV[0]) or die $!;


foreach (@lines) {
	print F $_;
}
