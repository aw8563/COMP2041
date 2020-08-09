#!/usr/bin/perl -w
$_argv = $#ARGV + 1; # hack to get $#


while (1) {
        $line = <STDIN>;

        chomp $line;
        print "$line\n";

        if ($line eq 'q') {
                print "FINISH\n";
                exit;
        } elsif ($line eq "JKLDSJFLKSJDFKL") {
                print "????\n";
        } else {
                print "q to quit\n";
        }
}
