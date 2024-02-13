#!/usr/bin/perl
# counts gap characters and ambiguous bases per sequence in an aligned multifasta file
# command line argument is <input file>; output is tab-delimited file
# by Jen Knack

use strict;
use warnings;

# store command line argument
my $infile = $ARGV[0];

# open input and output files
$infile =~ m/^(.+)\.(\w+)$/;
my $filebase = $1;
my $fileext = $2;
my $outfile = $filebase . "_AFAstats.txt";
open(INPUT, '<', $infile) or
	die "Cannot open $infile: $!\n";
open(OUTPUT, '>', $outfile) or
	die "Cannot open/create $outfile: $!\n";

# count the non-gap characters in each sequence
while (<INPUT>) {
	my ($basecount,$nonambicount,$ambicount);
	if (m/^>(\S+)/) {
		my $seqname = $1;
		print OUTPUT $seqname;
		($basecount,$nonambicount,$ambicount) = 0;
	} else {
		while (m/[a-z]/ig) { $basecount++ }
		while (m/[^atgc-]/ig) { $nonambicount++ }
		$ambicount = $basecount - $nonambicount;
		print OUTPUT "\t$basecount\t$ambicount\n";
	}
}

# close up shop
close INPUT;
close OUTPUT;
