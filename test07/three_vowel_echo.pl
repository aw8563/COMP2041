#!/usr/bin/perl

%vowels;
$vowels{"a"} = 0;
$vowels{"e"} = 0;   
$vowels{"i"} = 0;   
$vowels{"o"} = 0;   
$vowels{"u"} = 0;   

%words;

foreach (@ARGV) {
	$nVowels = 0;
	
	
	if (exists($words{$_})) {
		next;
	}	
	
	$words{$_} = 0;	


	foreach $c (split("", lc($_))) {
		if (exists($vowels{$c})) {
			$nVowels++;
		} else {
			$nVowels = 0;
		}
		
		if ($nVowels >= 3) {
			print ("$_ ");	
			last;
		}
	} 
}

print ("\n");
