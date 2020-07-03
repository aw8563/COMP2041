#!/usr/bin/perl -w

foreach $arg (@ARGV) {
	
    if ($arg eq "--version") {
        print "$0: version 0.1\n";
        exit 0;
    # handle other options
    # ...
    } else {
        push @files, $arg;
    }
}

$n = 10;
$nFiles = $#ARGV + 1;


if ($#ARGV == -1) {
	@lines = ();
	while ($stdin = <>) {
		push @lines, $stdin;
	}

	while ($line = shift(@lines)) {
		if (scalar(@lines) < $n) {

			print ("$line");
		}	
	}
	exit 0;
}


if ("$ARGV[0]" =~ /^-[0-9]*$/) {
	$nFiles --;
}

foreach $file (@files) {
		

	if ("$file" =~ /^-[0-9]*$/) {
        	$n = -1*$file;
	} else {
	
	
	if ($nFiles > 1) {
		print ("==> $file <==\n");
	}

    	open F, '<', $file or die "$0: Can't open $file";
	
	$nLines = 0;

	while (<F>) {
		$nLines++;    		
    	}
	
	close F;
	
	open F, '<', $file;
	
	$count = 0;
	while ($line = <F>) {
		if ($nLines - $count <= $n) {
			print ("$line");
		}
		$count++;
	}
	close F;
	
	}
}
