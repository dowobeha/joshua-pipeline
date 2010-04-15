#!/usr/bin/perl -w

use strict;

scalar(@ARGV)==3 || die("Usage: $0 inputFile.sgm outputFile.sgm numSegments");

open(IN,  "<", $ARGV[0]) || die("Could not open input file ".$ARGV[0]);
open(OUT, ">", $ARGV[1]) || die("Could not open output file ".$ARGV[1]);

binmode(IN,  ":utf8");
binmode(OUT, ":utf8");

my $startCount=0;
my $endCount=0;
my $numSegments=0;
my $lastSegment=int($ARGV[2]);


print STDERR "Writing first $lastSegment segments of $ARGV[0] to $ARGV[1]\n";

my $processSegments="true";

while (defined(my $line=<IN>)) {
    
    chomp($line);

    if ($line=~/^\s*<seg/) {

	$numSegments += 1;

	if ($processSegments) {

	    $startCount+=1;

	    if ($line=~/seg>\s*$/) {
		$endCount+=1;
	    }

	    if ($startCount != $endCount) {
		die("Segment " . $numSegments . " cannot be processed, because the end tag </seg> does not end on the same line as the starting tag <seg>");
            } else {
		print OUT $line . "\n";
		if ($numSegments>=$lastSegment) {
		    $processSegments="";
		}
	    }
	}
    
    } else {

	print OUT $line . "\n";

    }



}

