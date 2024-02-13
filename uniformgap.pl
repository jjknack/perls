#!/usr/bin/perl
# changes all gap characters in an aligned fasta file to "-"
# command line argument is <input file>
# by Jen Knack

use strict;
use warnings;

# store command line argument
my $infile = $ARGV[0];

# open input and output files
$infile =~ m/^(.+)\.(\w+)$/;
my $filebase = $1;
my $fileext = $2;
my $outfile = $filebase . "_uniformgap." . $fileext;
open(INPUT, '<', $infile) or
	die "Cannot open $infile: $!\n";
open(OUTPUT, '>', $outfile) or
	die "Cannot open/create $outfile: $!\n";

# change all gap characters in sequence lines to "-"
while (<INPUT>) {
	if (m/^>(.+)/) {
		print OUTPUT;
	} else {
		s/[.|_| ]/-/g;
		print OUTPUT;
	}
}

# close up shop
close INPUT;
close OUTPUT;
