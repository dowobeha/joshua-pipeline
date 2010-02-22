#!/usr/bin/perl -w

use strict;

scalar(@ARGV)==4 || die("Usage: $0 inputFile.src inputFile.tgt outputFile.src outputFile.tgt");

open(IN1, "<", $ARGV[0]) || die("Could not open input file ".$ARGV[0]);
open(IN2, "<", $ARGV[1]) || die("Could not open input file ".$ARGV[1]);

open(OUT1, ">", $ARGV[2]) || die("Could not open output file ".$ARGV[2]);
open(OUT2, ">", $ARGV[3]) || die("Could not open output file ".$ARGV[3]);


binmode(IN1,  ":utf8");
binmode(IN2,  ":utf8");
binmode(OUT1, ":utf8");
binmode(OUT2, ":utf8");

my $wordLimit=100;
my $lineNumber=0;
my $linesSkipped=0;
my $blankLines=0;

while (defined(my $line1=<IN1>) && defined(my $line2=<IN2>)) {

    $lineNumber += 1;

    my @words1 = split(/\s+/, $line1);
    my @words2 = split(/\s+/, $line2);

    my $numWords1 = scalar(@words1);
    my $numWords2 = scalar(@words2);

    if ($numWords1==0 || $numWords2==0) {
	$blankLines += 1;
	print STDERR "Skipping aligned sentence number $lineNumber, with respective word counts of $numWords1 and $numWords2\n";
    } elsif ($numWords1>=$wordLimit || $numWords2>=$wordLimit) {
	$linesSkipped += 1;
	print STDERR "Skipping aligned sentence number $lineNumber, with respective word counts of $numWords1 and $numWords2\n";
    } else {
	print OUT1 $line1;
	print OUT2 $line2;
    }
}

print STDERR "Skipped $linesSkipped of $lineNumber aligned sentences because of excess length\n";
print STDERR "Skipped $blankLines of $lineNumber aligned sentences because of empty length\n";

close(IN1);
close(IN2);
close(OUT1);
close(OUT2);
