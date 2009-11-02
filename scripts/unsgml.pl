#!/usr/bin/env perl
use strict;
use warnings;

while (<STDIN>) {
	s/\s*<seg\s+id="[^"]*"\s*>\s*//i;
	s/\s*<\/seg\s*>//i;
	s/<doc.*>//i;
	s/<\/doc>//i;
	
	print $_ unless m/^\s*$/;
}
