#!usr/bin/perl
#read a RAMMCAP DNACLUSTERING-CLUSTERS file and
#extract names of clusters and number of reads in cluster
use warnings;
use strict;

#open files
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
$ARGV[0] =~ m/(.+)info\.txt/;
my $outputname = $1 . "list.txt";
open(OUTPUT, '>', $outputname)
	or die "Cannot create output file: $!\n";
	
#read lines and write read names to output
while (<INPUT>) {
	if (m/>(HTPU[^\.]+)/) {
		print OUTPUT "$1.fasta\n";
	}
}
close INPUT;
close OUTPUT;