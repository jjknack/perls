#!/usr/bin/perl
#Trim the forward primer off of amplicon reads in fasta format
#command  line arguments are <input file> followed by <primer sequence>
#by Jennifer Knack

use warnings;
use strict;

#store command line arguments
my $infile = $ARGV[0];
my $primer = uc($ARGV[1]);

#sub ambiguous nucleotides for something regex-compatible
$primer =~ s/R/(A|G)/g;
$primer =~ s/Y/(C|T)/g;
$primer =~ s/S/(G|C)/g;
$primer =~ s/W/(A|T)/g;
$primer =~ s/K/(G|T)/g;
$primer =~ s/M/(A|C)/g;
$primer =~ s/B/(C|G|T)/g;
$primer =~ s/D/(A|G|T)/g;
$primer =~ s/H/(A|C|T)/g;
$primer =~ s/V/(A|C|G)/g;
$primer =~ s/N/(A|T|G|C)/g;

#open input and output files
$infile =~ m/^(\w+)\.(\w+)$/;
my $filebase = $1;
my $fileext = $2;
my $outfile = $filebase . "_5trimmed." . $fileext;
open(INPUT, '<', $infile) or
	die "Cannot open $infile: $!\n";
open(OUTPUT, '>', $outfile) or
	die "Cannot open/create $outfile: $!\n";

#go through input file and delete all occurences of the primer, then save to output file
while (<INPUT>) {
	s/^.*$primer//;
	print OUTPUT;
}
close INPUT;
close OUTPUT;