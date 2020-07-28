#!/usr/bin/perl -w

use LWP::Simple;
$url = "http://www.timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
$web_page = get($url) or die "Unable to get $url";

#print $web_page;
@lines = split("\n", $web_page);
my %map;

$flag = 0;

foreach $line (@lines) {
		if ($line =~ /${ARGV[0]}[0-9]{4}/) {
			# get every seocnd line
			if ($flag) {
				$line =~ s/^\s*<td class=\"data\"><a href=\"//g;
				$line =~ s/<\/a><\/td>//g;
				$line =~ s/\.html\">/ /g;

				if (!exists $map{$line}) {
					print ("$line\n");
				}

				$map{$line} = "XD";
			}
			$flag = !$flag;
		}
}
