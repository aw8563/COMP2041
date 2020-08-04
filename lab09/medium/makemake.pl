#!/usr/bin/perl -w

open (MF, ">", "Makefile") or die $!;

$d = `date`;

print MF "#Makefile generated at $d\n";
print MF "CC = gcc\nCFLAGS = -Wall -g\n\n";

$main = "";

# check for a main in cwd
foreach $file (glob "*.c") {
	open (F, "<", $file) or die $!;

	while (my $line = <F>) {
		if ($line =~ /^\s*(int|void)\s*main\s*\(/) {
			$main = $file;
			$main =~ s/\.c//g;			
			last;
		}
	}	
	
	close F;
	if (!$main eq "") {
		last;
	}
}

print MF "$main:\t$main.o ";

# found our main file
if ($main eq "") {
	print ("no main found\n");
	exit 1;
}

my @objects = ();
push (@objects, $main);

open (F, "<" , "$main.c") or die $!;

# look for #include "xxxx"
while (my $line = <F>) {
	if ($line =~ /^\s*#include \".*\"/) {
		# retrieve the name of file
					
		$line =~ /(\".*\")/;		

		$include = $1;
		$include =~ s/\"//g;			
		$include =~s/\.h//g;		
	
		print MF "$include.o ";	
		
		# store it in our array
		push (@objects, $include);
	}
}

close F;

my @sorted = sort(@objects);


print MF "\n\t\$(CC) \$(CFLAGS) -o \$@";
foreach (@sorted) {
	print MF " $_.o";
}
print MF "\n\n";

foreach (@sorted) {
	print MF "$_.o:";
	
	# get #includes in each .c file
	open (F, "<", "$_.c") or die $1;
	
	while (my $line = <F>) {
		if ($line =~ /^\s*#include \".*\"/) {
	                # retrieve the name of file
                	$line =~ /(\".*\")/;
			$include = $1;

			$include =~ s/\"//g;			
			print MF " $include";	
		}
	}
	close(F);	
	print MF " $_.c\n";
}


close(MF);

