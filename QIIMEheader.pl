#!/usr/bin/perl
#Formats FASTA headers into the format output by QIIME's split_libraries.py
#command line arguments are <input file> followed by <sample name> followed by <barcode sequence>
#by Jennifer Knack, inspired by George Watts

use warnings;
use strict;

$ARGV[0] =~ m/^(\w+)/;
my $filebase = $1;
my $SampleID = $ARGV[1];
my $BarcodeSequence = $ARGV[2];
my $outfile = $filebase . "_QIIMEd.fasta";

open(INPUT, '<', $ARGV[0]) or
	die "could not open $ARGV[0]: $!\n";
open(OUTPUT, '>', $outfile) or
	die "could not open/create $outfile: $!\n";

my $count = 1;
while (<INPUT>) {
	if ($_ =~ m/^>(\S+)/) {
		my $readname = $1;
		print OUTPUT ">$SampleID" . "_" . "$count $readname orig_bc=$BarcodeSequence new_bc=$BarcodeSequence bc_diffs=0\n";
		$count++;
	} else {
		print OUTPUT $_;
	}
}

close INPUT;
close OUTPUT;