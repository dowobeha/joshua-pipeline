#!/usr/bin/perl -w 

# Restrict unsafe perl constructs
use strict;

# Verify that the user provided the correct number of arguments
scalar(@ARGV)==2 || die("Usage: $0 inputFile outputFile");


# If user supplied - as the first argument...
if ($ARGV[0] eq "-") {
    # ... read from standard input
    *IN=*STDIN;
} else {
    # ... otherwise, open the specified file
    open(IN, "<", $ARGV[0]) || die("Could not open input file ".$ARGV[0]);
}

# If user supplied - as the second argument
if ($ARGV[1] eq "-") {
    # ... write to standard output
    *OUT=*STDOUT;
} else {
    # ... otherwise, open the specified file
    open(OUT, ">", $ARGV[1]) || die("Could not open output file ".$ARGV[1]);
}

# Make sure we're reading and writing Unicode
binmode(IN,  ":utf8");
binmode(OUT, ":utf8");


# Read each line of the input
while (defined(my $line=<IN>)) {

      # Remove the _OOV marker from all words
      $line =~ s/_OOV//g;

      # Write the line to output
      print OUT $line;

}

# Close input and output files
close(IN);
close(OUT);

