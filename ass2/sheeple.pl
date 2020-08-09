#!/usr/bin/perl -w

# main function
sub main {
	# map to store our resulting file
	my @result = ();

	open (F, "<", "$ARGV[0]") or die $!;


	# main loop that reads the file and processes each line
	while (my $line = <F>) {

		# header line
		if (isHeader($line)) {
			push (@result, "#!/usr/bin/perl -w\n");
			next;
		}

		# remove \n
		chomp($line);

		# parse the line to do some conversions first
		($line, $comment) = parseLine($line);

		# if the line can be skipped
		if (skipLine($line)) {
			next;
		}

		# empty line
		if ($line =~ /^\s*$/) {
			push (@result, "$line$comment\n");
			next;
		}

		# closes brackets
		# fi, done
		if (isClosingBracket($line)) {
			push (@result, formatLine($line, "}", $comment, 1));
			next;
		}

		# variable assignment
		if (my ($lhs, $rhs) = isAssign($line)) {
			if ($lhs and $rhs and "$lhs" ne "" and "$rhs" ne "") {
				my $final = "";

				# assigning to a string with quotes/variable/number
				if ($rhs =~ /^\$/ or $rhs =~ /^[0-9]+$/ or $rhs =~ /^\".*\"/) {
					$final = "\$$lhs = $rhs";
				} else { # assigning to a string without quotes
					$final = "\$$lhs = \'$rhs\'"
				}

				push(@result, formatLine($line, $final, $comment));
				next;
			}
		}

		# buildin functions
		# exit read cd test expr echo
		if (my $output = isBuiltinFunction($line, $comment)) {
			push (@result, $output);
			next;
		}

		# checks for loops
		if (my ($iterator, $list) = isForLoop($line)) {
			if ($iterator and $list) {
				# construct the list
				$list = convertList($list);

				push (@result, formatLine($line, "foreach \$${iterator} \($list\) {", $comment, 1));
				next;
			}
		}

		# checks while loops
		if (my $condition = isWhileLoop($line)) {
			push(@result, formatLine($line, "while ($condition) {", $comment, 1));
			next;
		}

		# checks if else statement
		if (my ($statement, $condition) = isIfStatement($line)) {
			if ($statement){	
				# format properly depending on keyword
				if ($statement eq "else") {
					push (@result, formatLine($line, "} else {", $comment, 1));
					next;
				}

				if ($condition) {
					$bracket = "} ";
					# more formatting
					if ($statement eq "if") {
						$bracket = "";
					} else {
						$statement = "elsif";
					}

					push (@result, formatLine($line, "$bracket$statement $condition {", $comment, 1));
					next;
				}
			}
		}



		# if we reach here then the line should be untranslateable
		# use system() function isntead
		my $output = translateSystemCall($line);
		push(@result, formatLine($line, $output, $comment));
	}

	close(F);

	open (OUT, ">", "out.pl") or die $!;
	foreach(@result) {
		print "$_";
	}
	close(OUT);

	exit 0;
}

# converts all appropriate variables etc first
# $1 .. $9 -> $ARGV[0] .. $ARGV[9]
# $#, $@, $*
# test, `` and [condition]
sub parseLine {
	my $line = $_[0]; #

	# remove trailing comments first
	# make sure that the '#' is not enclosed within quotes
	my $nQuotes = 0;
	my $idx = 0;
	my $found = 0;

	foreach $char (split //, $line) {
 		if ($char eq "\'" or $char eq "\"") {
 			$nQuotes++;
 		}

 		if ($char eq "#" and $nQuotes%2 == 0) {
 			$found = 1;
 			last;
 		}

 		$idx++;
	}	

	my $comment = "";

	# comment from idx onwards
	if ($found) {
		$comment = substr($line, $idx);
		
		$copy = $comment;
		$regex = quotemeta $copy;

		# remove the comment from the line (will add it back later)
		# remoes the whitespace before comment as well (if the line isn't empty)
		if (!$line =~ /^\s*$regex$/) {
			$line =~ s/\s*$regex$//;
		} else {
			$line =~ s/$regex$//;
		}
	}


	# replace $#, $@ and $*
	$line =~ s/(\$\@)|(\"\$\@\")/\@ARGV/g;
	$line =~ s/(\$#)|(\"\$#\")/\$#ARGV/g;


	# $1..9
	while (1) {
		$line =~ /[^\\]\$([0-9])/;
		
		# no more replacements
		if (!$1) {
			last;
		} 

		$idx = $1 - 1;
		$regex = quotemeta $1;

		$line =~ s/\$$regex/\$ARGV[$idx]/;
	}


	# replace TEST keyword
	while (1) {
		$line =~ /.*test (.+)\s*$/;

		if (!$1) {
			last;
		}

		# replace the test section
		$condition = convertTestCondition($1);
		$regex = quotemeta $1;

		$line =~ s/test $regex/\($condition\)/;
	}


	# replace backticks ``
	# will just assume backticks are always used with expr
	while (1) {
		$line =~ /.*`expr (.+)`\s*$/;

		if (!$1) {
			last;
		}

		# replace the backticked section
		$expr = $1;
		$regex = quotemeta $1;

		$line =~ s/`expr $regex`/$expr/;
	}

	# replace [] conditions
	while (1) {
		$line =~ /^.*\[ (.+) \].*$/;

		if (!$1) {
			last;
		}

		# replace brackets with if condition
		$condition = convertTestCondition($1);
		$regex = quotemeta "$1";

		$line =~ s/\[ $regex \]/\($condition\)/;
	}

	return $line, $comment;
}



# checks if it is a header file
sub isHeader {
	return $_[0] =~ /^\s*#!\/bin\/(da){0,1}sh/;
}

# checks if a given line is a comment or purely whitespace
sub isComment {
	if ($_[0] eq "") {
		return 1;
	}

	return $_[0] =~ /^\s*#+/;
}

sub isWhileLoop {
	$_[0] =~ /^\s*while \((.+)\)/;
	return $1;
}

# checks if a line is an if statement
sub isIfStatement {
	if ($_[0] =~ /^\s*else/) {
		return "else", "";
	}

	$_[0] =~ /^\s*((if)|(elif)) (\(.+\))/;
	return $1, $4;
}

# checks if a given line is assigning a variable
# returns left hand side and righthand side of the match
sub isAssign {
	$_[0] =~ /^\s*([_a-zA-Z]{1}[a-zA-Z_0-9]*)=(.+)\s*/;
	return $1, $2;
}

# checks if a line is a FOR loop
# format is "for <iterator> in <list>"
# returns <iterator> and <list>
sub isForLoop {
	$_[0] =~ /^\s*for (.+) in (.+)\s*$/;
	return $1, $2;
}

# checks if a line is a shell function that requires translation to perl
# exit read cd test expr echo
# returns the translated line
sub isBuiltinFunction {
	my $line = $_[0];
	my $comment = $_[1];

	# exit
	if (isExit($line)) {
		return "$line;\n";
	}

	# read
	if (my $var = isRead($line)) {
		$line1 = formatLine($line, "\$$var = <STDIN>", $comment);
		$line2 = formatLine($line, "chomp \$$var", $comment);

		return "$line1\n$line2"; 
	}

	# cd
	if (my $dir = isChangeDir($line)) {
		return formatLine($line, "chdir '$dir'", $comment);
	}

	# test 


	# expr

	# echo
	if (my $arguments = isPrint($line)) {
		$arguments = createPrintString($arguments);
		return formatLine($line, "print $arguments", $comment);
	}	
}

# constructs a string to print
# adds the appropriate escape to quotes
sub createPrintString {
	# add a trailing space to make parsing easier!
	$string = "$_[0] ";
	$newline = 1;

	my @result = ();

	# check for -n flag
	if ($string =~ s/^-n //) {
		$newline = 0;
	}

	while (1) {
		# check quotes
		if ($string =~ "^\\s*\"([^\"]*)\"") {
			# need to escape ' and "
			$match = $1;
			$arg = $1;
			$arg =~ s/\"/\\\"/g;
			$arg =~ s/\'/\\\'/g;

			push(@result, $arg);

			$regex = quotemeta $match;
			$string =~ s/\"$regex\"//;
			next;
		}

		# check quotes
		if ($string =~ "^\\s*\'([^\']*)\'") {
			# need to escape ' and "
			$match = $1;
			$arg = $1;

			$arg =~ s/\"/\\\"/g;
			$arg =~ s/\'/\\\'/g;
			
			push(@result, $arg);
			$regex = quotemeta $match;
			$string =~ s/\'$regex\'//;

			next;
		}

		# nothing left
		if ($string =~ /^\s*$/) {
			last;
		}

		if ($string =~ "^\\s*([^\\s]*)(\\s+)") {
			push(@result, $1);
			$regex = quotemeta $1;
			$string =~ s/$regex //;			
		}
	}

	$final = "";
	foreach(@result) {
		if ($final eq "") {
			$final = "\"$_\"";
		} else {
			$final = "$final, \" $_\"";
		}
	}

	if ($newline) {
		$final = "$final, \"\\n\"";
	}

	return $final;
}

# skip the line
# ignores "do" and "then"
sub skipLine {
	# negative lookahead for "do" so we do not match "done"
	return $_[0] =~ /^\s*(do(?!ne))|(then)\s*$/;
}

# closes bracket on "done" and "fi"
sub isClosingBracket {
	return $_[0] =~ /^\s*(done)|(fi)\s*$/;
}

# checks if we are exiting
sub isExit {
	return $_[0] =~ /^\s*exit/;
}

# checks if we are changing directories
# returs the directory we are changing to
sub isChangeDir {
	$_[0] =~ /^\s*cd (.+)\s*$/;
	return $1;
}

# checks if a line is calling echo
# returns what is getting printed
sub isPrint {
	$_[0] =~ /^\s*echo (.*)\s*$/;
	return $1;
}


# checks if a line is calling read
# returns the variable we read into
sub isRead {
	$_[0] =~ /^\s*read (.+)\s*$/;
	return $1;
}

# returns required indentation for a line
sub getIndentation {
	$_[0] =~ /(^\s*)/;
	return $1;
}

# returns the translated system('...') line
sub translateSystemCall {
	$_[0] =~ /^\s*(.+)\s*$/;
	return "system \"$1\"";
}

# pad the converted line with indentation and trailing comments
sub formatLine {
	my $indent = getIndentation($_[0]);
	my $comment = $_[2]; 
	my $semicolon = ";";
	
	if ($_[3]) {
		$semicolon = "";
	}

	if ($comment ne "") {
		return "${indent}${_[1]}${semicolon} $comment\n";
	}

	return "${indent}${_[1]}${semicolon}\n";
}

# create the appropriate list to iterate over
sub convertList {
	$list = $_[0];

	# remove trailing spaces
	$list =~ s/\s*$//g;

	# split by space
	my @split = split(" ", $list);
	my $result = "";


	foreach(@split) {
		# glob it
		if ($_ =~ "[\*\[\?]") {
			$result = "${result}glob(\'$_\'), ";
		} else { # no glob 
			$result = "$result\'$_\', ";
		}
	}


	return $result;	
}

# converts shell test keyword to perl logic
sub convertTestCondition {
	$test = $_[0];

	# x = y format
	if ($test =~ /(.+) (=|!=|<=>|<|>|<=|>=) (.+)\s*$/) {
		# check what the comparison is
		$operation = $2;
		$comparator = "";

		if ($operation eq "=") {
			$comparator = "eq";
		} elsif ($operation eq "!=") {
			$comparator = "ne" 
		} elsif ($operation eq "<=>") {
			$comparator = "cmp" 
		} elsif ($operation eq "<") {
			$comparator = "lt" 
		} elsif ($operation eq ">") {
			$comparator = "gt" 
		} elsif ($operation eq "<=") {
			$comparator = "le" 
		} elsif ($operation eq ">=") {
			$comparator = "ge" 
		} 

		return "\'$1\' $comparator \'$3\'";
	}


	# x <operator> y format. operation (eq|ne|lt|gt|le|ge|)
	if ($test =~ /(.+) -(eq|ne|cmp|lt|gt|le|ge) (.+)\s*$/) {
		$comparator = $2;
		$operator = "";

		if ($comparator eq "eq") {
			$operator = "=";
		} elsif ($comparator eq "ne") {
			$operator = "!=";
		} elsif ($comparator eq "cmp") {
			$operator = "<=>";
		} elsif ($comparator eq "lt") {
			$operator = "<";
		} elsif ($comparator eq "gt") {
			$operator = ">";
		} elsif ($comparator eq "le") {
			$operator = "<=";
		} elsif ($comparator eq "ge") {
			$operator = ">=";
		}

		return "$1 $operator $3";
	}

	# -r flag
	if ($test =~ /^-r (.+)\s*$/) {
		return "-r \'$1\'";
	}

	# -d flag
	if ($test =~ /^-d (.+)\s*$/) {
		return "-d \'$1\'";
	}

	return;
	# we shouldn't actually get here
}

main()
