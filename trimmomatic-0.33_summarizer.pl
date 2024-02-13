#!/usr/bin/perl
# Calculates average sequence length, location of first surviving base, location
# of last surviving base, and amount trimmed from a Trimmomatic 0.33 log file
# command line argument is <input log file>
# by Jennifer Knack

use strict;
use warnings;

open(INPUT, '<', $ARGV[0]) or
	die "Cannot open $ARGV[0]: $!\n";

my @totals = (0,0,0,0);
my $count = 0;
while (<INPUT>) {
	if (m/(\d+) (\d+) (\d+) (\d+)$/) {
		$count++;
		$totals[0] = $totals[0] + $1;
		$totals[1] = $totals[1] + $2;
		$totals[2] = $totals[2] + $3;
		$totals[3] = $totals[3] + $4;
	} else {
		next;
	}
}

close INPUT;

# FOR DEBUG print join(" ",@totals);

my @averages;
$averages[0] = $totals[0] / $count;
$averages[1] = $totals[1] / $count;
$averages[2] = $totals[2] / $count;
$averages[3] = $totals[3] / $count;

printf("Average surviving sequence length: %d\nAverage location of the first surviving base: %d\nAverage location of the last surviving base: %d\nAverage amount trimmed from the end: %d\n",@averages[0..3]);
