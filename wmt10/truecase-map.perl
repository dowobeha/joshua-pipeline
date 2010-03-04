#!/usr/bin/perl -w
#
# truecase-map.perl
# -----------------
# This script outputs alternate capitalizations

%map = ();
while($line = <>) {
    @words = split(/\s+/, $line);
    foreach $word (@words) {
	$key = lc($word);
	$map{$key}{$word} = 1;
    }
}

foreach $key (sort keys %map) {
    @words = keys %{$map{$key}};
    if(scalar(@words) > 1 || !($words[0] eq $key)) {
	print $key;
	foreach $word (sort @words) {
	    print " $word";
	}
	print "\n";
    }
}
