#!/usr/bin/perl


my @result;
$max;

while (<STDIN>) {
	foreach $number (split(" ", $_)) {
		#while ($number =~ /([+-]?((\d+(\.\d*)?)|(\.\d+)))/) {
		#	print "$1 ";
		#}				
	
		if ($number =~ /^[-]{0,1}\d*\.?\d*$/) {		
			if (!defined($max) || $number >= $max) {
				if (!defined($max) || $number > $max) {
					$max = $number;
					@result = ();
				}	
				push(@result, $_);
			} 
			
				
		}
	}
}

foreach (@result) {
	print ($_);	
}
