#!usr/bin/perl
#read a RAMMCAP DNACLUSTERING-CLUSTERS file and
#extract names of clusters and number of reads in cluster
use warnings;
use strict;

#open file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
	
#read lines and create hash of clusters
my (%clusters, $cluster, $count);
while (<INPUT>) {
	if (m/^>(Cluster \d+)/) {
		$cluster = $1;
		$count = 0;
	} else {
		$count++;
		$clusters{$cluster} = $count;
	}
}
close INPUT;

#open and write hash to output
open(OUTPUT, '>', 'clustercount.txt')
	or die "Cannot create output file: $!\n";
while (my ($key, $value) = each %clusters) {
	print OUTPUT "$key\t$value\n";
}
close OUTPUT;