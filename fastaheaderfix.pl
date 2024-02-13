#!/usr/bin/perl
# Rename RDP headers in a multifasta file so that "Genus_species" is listed first
# Command line argument is <input file>
# by Jennifer Knack

use strict;
use warnings;

my $input = $ARGV[0];
my $filename;
if ($input =~ /(.+)\.fa/) {
	$filename = $1;
} else {
	die "Please input file name.\n";
}
my $output = $filename . "_headerfixed.fasta";

open(INPUT, '<', $input) or
	die "Cannot open $input: $!\n";
open(OUTPUT, '>', $output) or
	die "Cannot open $output: $!\n";

while (<INPUT>) {
	if (m/^>(S\d+) (\w+) (\w+)(.+)/) {
		my ($Snumber,$genus,$species,$therest) = ($1,$2,$3,$4);
		chomp($Snumber,$genus,$species,$therest);
		my $line = ">" . $genus . "_" . $species . $therest . "; " . $Snumber;
		print OUTPUT "$line\n";
	} else {
		print OUTPUT;
	}
}

close INPUT;
close OUTPUT;
