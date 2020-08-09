#!/usr/bin/perl -w

# main function
sub main {
	# map to store our resulting file
	my @result = ();

	open (F, "<", "$ARGV[0]") or die $!;


	# main loop that reads the file and processes each line
	while (my $line = <F>) {
		chomp($line);
		$line = replaceVariables($line);

		# if the line can be skipped
		# shell if and while statements use 2 lines while in perl only 1 line is used
		if (skipLine($line)) {
			next;
		}

		# closes brackets
		# fi, done
		if (isClosingBracket($line)) {
			push (@result, formatLine($line, "}"));
			next;
		}

		if (isHeader($line)) {
			push (@result, "#!/usr/bin/perl -w\n");
			next;
		}

		# copy comments over
		if (isComment($line)) { 
			push (@result, $line);
			next;
		} 

		# variable assignment
		if (my ($lhs, $rhs) = isAssign($line)) {
			if ($lhs and $rhs) {
				push(@result, formatLine($line, "\$$lhs = \'$rhs\'"));
				next;
			}
		}

		# buildin functions
		# exit read cd test expr echo
		if (my $output = isBuiltinFunction($line)) {
			push (@result, $output);
			next;
		}

		if (my ($iterator, $list) = isForLoop($line)) {
			if ($iterator and $list) {
				# construct the list
				$list = createList($list);

				push (@result, formatLine($line, "foreach \$${iterator} \($list\) {"));
				next;
			}
		}



		# if we reach here then the line should is untranslateable
		# use system() function isntead
		my $output = translateSystemCall($line);
		push(@result, $output);
	}

	close(F);

	open (OUT, ">", "out.pl") or die $!;
	foreach(@result) {
		print "$_";
	}
	close(OUT);

	exit 0;
}

# converts special variables
# eg $1 -> $ARGV[0]
sub replaceVariables {
	my $line = $_[0];

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

	return $line;
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
	$line = $_[0];

	# exit
	if (isExit($line)) {
		return "$line;\n";
	}

	# read
	if (my $var = isRead($line)) {
		$line1 = formatLine($line, "$indent\$$var = <STDIN>");
		$line2 = formatLine($line, "chomp \$$var");

		return "$line1\n$line2"; 
		# $indent = getIndentation($line);
		# return "$indent\$$var = <STDIN>;\n${indent}chomp \$$var;\n";
	}

	# cd
	if (my $dir = isChangeDir($line)) {
		return formatLine($line, "chdir '$dir'");

		# $indent = getIndentation($line);
		# return "${indent}chdir '$dir';\n";
	}

	# test 

	# expr

	# echo
	if (my $arguments = isPrint($line)) {
		return formatLine($line, "print \"$arguments\\n\"");
		# $indent = getIndentation($line);
		# return "${indent}print \"$arguments\\n\";\n";
	}	
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

# returns any comments at the end of a line
sub getComments {
	$_[0] =~ /^\s*(#.*$)/;
	return $1;
}

# returns the translated system('...') line
sub translateSystemCall {
	$indent = getIndentation($_[0]);
	$_[0] =~ /^\s*(.+)\s*$/;
	return "${indent}system \"$1\";\n";
}

# pad the converted line with indentation and trailing comments
sub formatLine {
	$indent = getIndentation($_[0]);
	$comments = getIndentation($_[0]);

	return "${indent}${_[1]}; $comments\n";
}

# create the appropriate list to iterate over
sub createList {
	$list = $_[0];

	# remove trailing spaces
	$list =~ s/\s*$//g;

	# directory
	if ($list =~ /^\*/) {
		return "glob(\"$list\")";
	}

	# list of items.

	# replace spaces with "', '"
	$list =~ s/\s/\', \'/g;

	return "\'$list\'";	
}
main()
