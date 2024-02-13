#!/usr/bin/perl
# written by jjknack
# Reads a csv file of search-and-replace strings
#  (format: <search for this string>,<replace with this string>\n),
#  and performs a search-and-replace in the specified file.
# Input arguments: <csv file> <file to search>

use strict;
use warnings;

# Read input arguments
my ($csv,$infile) = @ARGV;
die "Arguments are <csv file> and <file to search>\n" unless (exists $ARGV[1]);
my ($filename,$fileext);
if ($infile =~ m/^(\S+)\.(\S+)$/) {
	$filename = $1;
	$fileext = $2;
} else {
	die "You fail at file names\n";
}

# Open input and output files
my $outfile = $filename . "_search-and-replace." . $fileext;
open(IN, '<', $infile) or
	die "Cannot open input file: $!\n";
open(CSV, '<', $csv) or
	die "Cannot open csv file: $!\n";
open(OUT, '>', $outfile) or
	die "Cannot open output file $!\n";

# Read csv into a hash
my %csv;
while (<CSV>) {
	if ( m/^([^,]+),([^,]+)$/ ) {
		$csv{$1} = $2;
	} else {
		next;
	}
}
#foreach my $key (keys %csv) { print "$key, $csv{$key}\n"; }
close CSV;

# Search the input file for the keys in the csv hash and replace with the corresponding value
while (<IN>) {
	foreach my $key (keys %csv) { s/$key/$csv{$key}/g; }
	print OUT;
}
close IN;
close OUT;
