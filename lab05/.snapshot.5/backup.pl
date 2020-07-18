#!/usr/bin/perl


my $file = $ARGV[0];
my $version = 0;

while (1) {
	if ( ! -e ".${file}.${version}") {
		print ("Backup of '$file' saved as '.$file.$version'\n");
			
		`cp "$file" ".$file.$version"`;
		exit 0;
	}
	
	$version++;
}
