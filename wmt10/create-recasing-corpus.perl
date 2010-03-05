#!/usr/bin/perl -w

# Ensure that the program has been called with three parameters
if (@ARGV < 2) {
    print STDERR "Usage: $0 input.truecased output.lowercased\n";
    exit -1;
}


# Open truecased file for reading
open(UPPER, "<", $ARGV[0]) or die("Unable to open input file: $ARGV[0]\n");

# Open file for writing lowercased output
open(LOWER, ">", $ARGV[1]) or die("Unable to write to lowercased output file: $ARGV[1]\n");


# Read one line at a time from truecased input file
while(my $line = <UPPER>) {

    # Lowercase input
    my $lower = lc $line;
    
    # Output lowercased sentence
    print LOWER $lower;

}


# Close all files
close(LOWER);
close(UPPER);
