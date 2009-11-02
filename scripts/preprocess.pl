#!/usr/bin/env perl
# Updated 2009-09-29 17:35:45-04:00 to allow explicit input and output files
# Updated 2009-06-03T21:43:26-04:00 to strip extra NIST MTeval xml tags
# Updated 2008-10-11T18:21:00-04:00 to strip <hl> and <poster> tags too
# Updated 2008-10-03T13:45:45-04:00 to strip <refset> tags
# Updated 2008-09-06T23:26:07-04:00 to strip more <doc> tags
# Updated 2008-09-05T04:23:55-04:00 to strip more SGML tags
use strict;
use warnings;

use utf8; # BEWARE

($#ARGV + 1 == 2) || die "Usage: $0 infile outfile\n";

open(INPUT, "<$ARGV[0]");
open(OUTPUT, ">$ARGV[1]");

binmode INPUT,  ":encoding(UTF-8)";
binmode OUTPUT, ":encoding(UTF-8)";

# Set the output record separator to be the same as $/ just like the -l flag to perl
$\ = "\n";

my $warn_p_exists = 0;

while(<INPUT>) {
	chomp;
	
	# ~~~~~ First, remove all SGML/XML
	s/<\?xml\s+version="[^"]*"(?:\s+encoding="[^"]*")?\s*\?>//i;
	s/<!doctype\s+(?:[^">]*(?:"[^"]*")?)*>//i;
	s/<mteval\s*>//i;
		s/<\/mteval\s*>//i;
		
	s/<srcset(?:\s+(?:setid|srclang|trglang)="[^"]*")*\s*>//i;
		s/<\/srcset\s*>//i;
	s/<refset(?:\s+(?:setid|srclang|trglang)="[^"]*")*\s*>//i;
		s/<\/refset\s*>//i;
	s/<doc(?:\s+(?:docid|genre|sysid)="[^"]*")*\s*>//i;
		s/<\/doc\s*>//i;
	foreach my $tag (qw(p hl poster)) {
		s/<$tag\s*>//i and $warn_p_exists++;
			s/<\/$tag\s*>//i;
	}
	# BUG: this seems not to be firing enirely right (see mt06 mert for mt09 dryrun; or was that preprocess done earlier?)
	#s/<seg\s+id="[^"]*"\s*>//i;
		       s/<seg\s+id=\S+\s*>//i;
		s/<\/seg\s*>//i;
	
	next if m/^\s*$/;
	
	# ~~~~~ Second, remove IBM classes
	s/\$[A-Za-z]+_\(([^|]+)\|\|([^)]+)\)/$1/g;
	s/\@\@/ /g;
	s/\$[A-Za-z]+_\(([^)]+)\)/$1/g;

	# ~~~~~ Third, interpret arabic punctuation
	# BEWARE of the utf8 encoding
	$_ = " $_ ";
	s/�m/ " /g;
	s/�n/ " /g;
	s/�v/ - /g;
	s/�c/ -- /g;
	s/�x/*/g;
	s/� s/ 's/g;
	s/�//g;
	s/…/ ... /g;
	s/―/ - /g;
	s/–/ - /g;
	s/─/ - /g;
	s/—/ - /g;
	s/•/ * /g;
	s/،/ , /g;
	s/؟/ ? /g;
	s/ـ/ /g;
	s/Ã ̄/i/g;
	s/â€™/ '/g;
	s/â€"/ " /g;
	s/؛/ ; /g;
	
	# Remove extraneous whitespace
	s/\s+/ /g;
	s/^\s+//;
	s/\s+$//;
	
	# Interpret SGML entities
	s/& amp ;/\&/g;
	s/& quot ;/\"/g;
	s/& squot ;/\'/g;
	s/& lt ;/\</g;
	s/& gt ;/\>/g;

	

    print OUTPUT lc($_);

}

close(OUTPUT);
close(INPUT);

warn "*** Found <p> tags. Be sure to process the reference sets so they're still aligned\n"
	if $warn_p_exists;

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ fin.
