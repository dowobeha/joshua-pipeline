#!/usr/bin/perl -wT

###############################################################################
###############################################################################
####                                                                       ####
####                      Post-processing script                           ####
####                     written by Lane Schwartz                          ####
####                                                                       ####
###############################################################################
###############################################################################

# Perl lets you do dumb things. Let's try not to.
use strict;

# Assume input and output should be unicode
binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

# Read one line at a time
while (my $line=<STDIN>) {

    # Remove final newline
    chomp($line);

    # Split line into words
    my @words = split(/\s+/, $line);

    # Iterate through the words in the line
    for (my $i=0; $i<@words; $i+=1) {

	# Remove explicit OOV marker
	if ($words[$i] =~ s/_OOV//g  ||  $i==0) {

	    # Uppercase first letter 
	    #   of the first word in the sentence and
	    #   of any out-of-vocabulary (OOV) words
	    $words[$i] = ucfirst($words[$i]);
	}
    }

    # Rejoin words, adding one space between each word
    $line = join(' ', @words);

    # Print post-processed line
    print $line."\n";

}

# Go home and party
