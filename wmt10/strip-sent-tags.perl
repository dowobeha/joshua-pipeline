#!/usr/bin/perl -w

while($line = <>) {
    $line =~ s/^\s*<s>\s*//g;
    $line =~ s/\s*<\/s>\s*$//g;
    print $line . "\n";
}

