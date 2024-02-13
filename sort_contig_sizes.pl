#!usr/bin/perl
#Pull each fasta header from a multifasta contig file from SeqMan NGen 4,
#sort them by decreasing size, and write to another file. Uses hash: MEMORY INTENSIVE.
#Argument is <multifasta contig file>. By Jen Knack

use strict;
use warnings;

#open input multifasta contig file
open(INPUT, '<', $ARGV[0]) or
	die "Cannot open input file: $!\n";
	
#read input file, find headers, and enter into hash
my %headers;
while (<INPUT>) {
	if (m/^>(.+reads), (\d+) bases/) {
		$headers{$2} = $1;
	}
}
close INPUT;

#open output and write alphabetized hash keys to list
open(OUTPUT, '>', 'sorted_contig_headers.txt') or
	die "Cannot open/create output file: $!\n";
foreach my $key (sort {$b <=> $a} keys %headers) {
	print OUTPUT "$headers{$key}\t($key bp)\n";
}
close OUTPUT