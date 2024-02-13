#!/usr/bin/perl
#Pull result descriptions from an outfmt=0 blast file, enter them into a hash,
#then write them to a file, one per line.  By Jen Knack
#Note: also gives "Database:" and "Number" within the list; manually delete those.

use strict;
use warnings;

#open input blast file
$ARGV[0] =~ m/(\w+)\.(\w+)$/;
my $basename = $1;
my $filetype = $2;
$filetype =~ m/txt/ or
	die "Input file is not formatted correctly.\n";
open(INPUT, '<', $ARGV[0]) or
	die "Cannot open input file: $!\n";
	
#read input file, find results, and enter into hash
my %results;
while (<INPUT>) {
	if ($_ =~ m/^\s\s(\S+)/) {
		$results{$1} = 1;
	} else {
		next;
	}
}
close INPUT;

#open output and write alphabetized hash keys to list
my $outputfile = $basename . "_list.txt";
open(OUTPUT, '>', $outputfile) or
	die "Cannot open/create output file: $!\n";
foreach my $key (sort keys %results) {
	print OUTPUT "$key\n";
}
close OUTPUT