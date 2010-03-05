#!/usr/bin/perl -w

# Ensure that the program has been called with three parameters
if (@ARGV < 2) {
    print STDERR "Usage: $0 input.truecased output.alignment\n";
    exit -1;
}


# Open truecased file for reading
open(UPPER, "<", $ARGV[0]) or die("Unable to open input file: $ARGV[0]\n");

# Open file for writing alignments output
open(ALIGN, ">", $ARGV[1]) or die("Unable to write to alignments output file: $ARGV[2]\n");


# Read one line at a time from truecased input file
while(my $line = <UPPER>) {

    # Get number of words in input
    my $wordCount = scalar(my @words=split(/\s+/, $line));		

    # Print one-to-one alignment data
    if ($wordCount > 0) {

	print ALIGN "0-0";

	for (my $i = 1; $i < $wordCount; $i++) {
	    print ALIGN " $i-$i";
	}
    }
    print ALIGN "\n";

}


# Close all files
close(ALIGN);
close(UPPER);
