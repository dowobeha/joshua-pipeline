#!/usr/bin/perl -w

# Ensure that the program has been called with correct number of parameters
if (@ARGV < 2) {
    print STDERR "Usage: $0 out.src out.tgt\n";
    exit -1;
}



# Open file for writing source text
open(SRC, ">", $ARGV[0]) or die("Unable to write to output file: $ARGV[1]\n");

# Open file for writing source text
open(TGT, ">", $ARGV[1]) or die("Unable to write to output file: $ARGV[1]\n");

# Assume input and output should be unicode
binmode(STDIN, ":utf8");
binmode(SRC, ":utf8");
binmode(TGT, ":utf8");

# Read one line at a time
while (my $line=<STDIN>) {

    # Remove final newline
    chomp($line);

    # Split line into words
    my @parts = split(/\t/, $line);

    # Print source text
    print SRC $parts[1]."\n";

    # Print target text
    print TGT $parts[2]."\n";

}


# Close all files
close(SRC);
close(TGT);
