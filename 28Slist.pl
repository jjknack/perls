#!usr/bin/perl
#read a RAMMCAP RRNAIDENFICATION-RRNAFASTA file and
#create a list of headers of only the 28S sequences
use warnings;
use strict;

#open file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
open(OUTPUT, '>', '28Slist.txt')
	or die "Cannot create output file: $!\n";	
	
#read lines and write if 28S
while (<INPUT>) {
	if (m/^>(\S+).+28S_rRNA$/) {
		print OUTPUT "$1.fasta\n";
	}
}
close INPUT;
close OUTPUT;