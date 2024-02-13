#!/usr/bin/perl
# Remove dimer repeats from sequence
# command  line argument is <input file>
# INCOMPLETE
# by Jennifer Knack

use warnings;
use strict;

#store command line argument
my $infile = $ARGV[0];

#open input and output files
$infile =~ m/^(.+)\.(\w+)$/;
my $filebase = $1;
my $fileext = $2;
my $outfile = $filebase . "_dimergone." . $fileext;
open(INPUT, '<', $infile) or
	die "Cannot open $infile: $!\n";
open(OUTPUT, '>', $outfile) or
	die "Cannot open/create $outfile: $!\n";

#go through input file and delete all dimer repeats of 8 or more, then save to output file
while (<INPUT>) {
	s/([ACGT][ACGT]){4}//g;
	print OUTPUT;
}
close INPUT;
close OUTPUT;
