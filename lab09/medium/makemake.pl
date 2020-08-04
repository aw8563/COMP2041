#!/usr/bin/perl -w


# given a file, get all #includes
sub getIncludedFiles {
	$file = $_[0];

	my @result = ();

	open (F, "<" , "$file") or die $!;

	# look for #include "xxxx"
	while (my $line = <F>) {
		if ($line =~ /^\s*#include \".*\"/) {
			# retrieve the name of file				
			$line =~ /(\".*\")/;		

			$include = $1;
			
			# remove quotes and .h
			$include =~ s/\"//g;			
			$include =~s/\.h//g;		
			
			# store it in our array
			push (@result, $include);
		}
	}
	close (F);

	return @result;
}

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

######################################################################
# we have our main here
# logic for constructing the Makefile 


# found our main file
if ($main eq "") {
	print ("no main found\n");
	exit 1;
}

my %objects = ($main, 1);

my @stack = getIncludedFiles("$main.c");

while (1) {
	$size = @stack;
	if ($size == 0) {
		last;
	}

	$o = pop(@stack);
	
	# append to queue if we have more elments to consider
	if (!defined($objects{$o})) {
		@arr = getIncludedFiles("$o.h");
		push(@stack, @arr);
	}

	$objects{$o} = 1;
}

print MF "$main:\t";
foreach my $key (keys %objects) {
	print MF "$key.o ";
}

print MF "\n\t\$(CC) \$(CFLAGS) -o \$@";
foreach my $key (keys %objects) {
	print MF " $key.o";
}

print MF "\n\n";

# go through each object file, and find associated headers and in the .c file
foreach my $object (keys %objects) {
	print MF "$object.o: ";

	my @arr = getIncludedFiles("$object.c");
	foreach (@arr) {
		print MF "$_.h ";
	}


	print MF "$object.c\n";
}


close(MF);

