#!/usr/bin/env perl
# This is a preprocessing script to remove sentence initial w#
# from Arabic when it is not supported by an "and" on the English
# side of an aligned corpus.
#
# N.B. this script must be run before reprocess_add-boundaries.pl

use strict;
use warnings;
use 5.008;           # Required for the next line, just to be safe
use encoding "utf8"; # N.B. ''use utf8'' does not work to enable utf8 regexes

use lib "/scratch/lane/pipeline/scripts";
use ParallelReprocess;

ParallelReprocess::setExtentionDefaults();
$ParallelReprocess::Ext_pp = '.rmW';
ParallelReprocess::parseARGV();

my $ChangeCount = 0;
ParallelReprocess::reprocessFiles(\&removeW);
print "Removed w# from $ChangeCount lines\n";
exit 0;


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
BEGIN {
	
	# The arabic U (و) character followed by an ATB-segmentation #-marker
	# N.B. it is not actually the arabic W (ش) character.
	my $W = "\x{0648}#";
	
	sub removeW { my ($arR, $enR, $alignR) = @_;
		
		# N.B. it's tricksy making sure this unicode regex fires.
		# Doing so requires the ''use encoding'' line and also ''binmode''
		if ($$arR =~ m/^$W\s+/ and $$enR !~ m/^and\s+/i) {
			$$arR =~ s/^$W\s+//;
			
			my @realign;
			foreach (@$alignR) {
				my ($a,$e) = $_ =~ m/^(\d+)-(\d+)$/
					or die "malformed alignment";
				push @realign,
					($a - 1) .'-'. $e
					unless 0 == $a;
			}
			@$alignR = @realign;
			
			++$ChangeCount;
		}
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ fin.
