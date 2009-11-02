# This package is for consolidating re-preprocessing scripts on
# parallel corpora, which are already word-aligned. Note that some
# reprocessing may invalidate the word alignments (even when the
# alignments are updated, since adding or removing words can alter
# how alignment is done).

package ParallelReprocess;

use 5.008;           # Required for the next line, just to be safe
use encoding "utf8"; # N.B. ''use utf8'' does not work to enable utf8 regexes

use warnings;
use strict;
use vars qw($Ext_ar $Ext_en $Ext_align $Ext_pp $BaseFilename);

use Getopt::Long;


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~ Usage

# setExtentionDefaults();
# ...set new defaults...
# parseARGV();
# ...other munging...
# reprocessFiles(\&f, \&g, \&h,...);
# ...other munging...
# exit 0;

# Where the functions passed to reprocessFiles accept three references as
# arguments: an Arabic line, an English line, and an array of alignments 


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~ ARGV parsing

sub setExtentionDefaults {
	$Ext_ar    = '.0.ar';
	$Ext_en    = '.0.en';
	$Ext_align = '.grow-diag-final-and';
	$Ext_pp    = '.reprocessed';
}


sub parseARGV {
	my $help = 0;
	GetOptions(
		'help|?'  => \$help,
		'ar=s'    => \$Ext_ar,    # N.B. can't use short form of --ar
		'en=s'    => \$Ext_en,
		'align=s' => \$Ext_align, # ...because -a would conflict with this
		'pp=s'    => \$Ext_pp,
	);
	
	printUsage() if $help;
	($BaseFilename) = @ARGV;
	printUsage() unless 1 == @ARGV and $BaseFilename;
	shift @ARGV;
}


# cf also Pod::Usage, though that makes printing the defaults hard
sub printUsage {
	setExtentionDefaults();
	print <<__EOF__;
Usage: $0 [options] \$base_filename

Options:
	--help          Show this message
	--ar    \$ar     Set the Arabic suffix          (default: $Ext_ar)
	--en    \$en     Set the English suffix         (default: $Ext_en)
	--align \$align  Set the Ar-En alignment suffix (default: $Ext_align)
	--pp    \$pp     Set the preprocess suffix      (default: $Ext_pp)
	
Files:
	The program takes these files as input:
		\$base_filename\$ar
		\$base_filename\$en
		\$base_filename\$align
	...and generates these files as output:
		\$base_filename\$pp\$ar
		\$base_filename\$pp\$en
		\$base_filename\$pp\$align
__EOF__
	exit 1;
}


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~ Main processing

sub reprocessFiles { my @functions = @_;
	
	my ($IN_ar, $IN_en, $IN_align, $OUT_ar, $OUT_en, $OUT_align); {
		$IN_ar     = safeOpen('<', $BaseFilename . $Ext_ar);
		$IN_en     = safeOpen('<', $BaseFilename . $Ext_en);
		$IN_align  = safeOpen('<', $BaseFilename . $Ext_align);
		
		$OUT_ar    = safeOpen('>', $BaseFilename . $Ext_pp . $Ext_ar);
		$OUT_en    = safeOpen('>', $BaseFilename . $Ext_pp . $Ext_en);
		$OUT_align = safeOpen('>', $BaseFilename . $Ext_pp . $Ext_align);
		
		# This is needed (on Arabic at least) in order to get the regex to fire
		binmode $_, ":encoding(UTF-8)"
			foreach ($IN_ar, $IN_en, $IN_align, $OUT_ar, $OUT_en, $OUT_align);
	}
	
	
	while (my $lines = parallelGetline($IN_ar, $IN_en, $IN_align)) {
		my ($ar, $en, $align) = @$lines;
		chomp $ar;
		chomp $en;
		chomp $align;
		my @align = split /\s+/, $align;
		
		&$_(\$ar, \$en, \@align)
			foreach @functions;
		
		print $OUT_ar    $ar, "\n";
		print $OUT_en    $en, "\n";
		print $OUT_align (join ' ', @align), "\n";
	}
}


sub safeOpen { my ($mode, $filename) = @_;
	open my $fh, $mode, $filename
		or die "Couldn't open file: $filename\n";
	return $fh;
}


sub parallelGetline {
	my $fh   = shift @_;
	my $line = <$fh>;
	
	if (defined $line) { # Try to detect parallel eof
		my @lines = ($line);
		foreach $fh (@_) {
			$line = <$fh>;
			die "unaligned lines at end of file"
				unless defined $line;
			push @lines, $line;
		}
		return \@lines;
		
	} else {
		foreach $fh (@_) {
			$line = <$fh>;
			die "unaligned lines at end of file"
				if defined $line;
		}
		return undef;
	}
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ fin.
1;
__END__
