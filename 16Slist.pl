#!usr/bin/perl
#read a RAMMCAP RRNAIDENFICATION-RRNAFASTA file and
#create a list of headers of only the 16S sequences
use warnings;
use strict;

#open file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
open(OUTPUT, '>', '16Slist.txt')
	or die "Cannot create output file: $!\n";	
	
#read lines and write if 16S
while (<INPUT>) {
	if (m/^>(\S+).+16S_rRNA$/) {
		print OUTPUT "$1.fasta\n";
	}
}
close INPUT;
close OUTPUT;