#!/usr/bin/perl
# Splits PE Illumina reads that have been randomly merged
# input the merged PE file (fasta, afa, or fastq format)
# outputs the forward reads in one file and the reverse reads in another.
# by jjknack

use strict;
use warnings;
use Bio::SeqIO;

# parse infile name
my $infile = $ARGV[0];
my ($filebase,$fileext,$filetype);
if ($infile =~ /(.+)\.([A-Za-z0-9]+)/) {
	($filebase,$fileext) = ($1,$2);
} else {
	die "Cannot parse input file name.\n";
}
if ($fileext =~ /fasta|fa|afa|fna/i) {
	$filetype = 'fasta';
} elsif ($fileext =~ /fastq|fq/i) {
	$filetype = 'fastq';
} else {
	die "Cannot determine input file format from the file name.\n";
}

# open seq files
my $seqin = Bio::SeqIO->new(-format => $filetype, -file => $infile);
my $seqout1P = Bio::SeqIO->new(-format => $filetype, -file => '>'.$filebase.'_1P.'.$fileext);
my $seqout2P = Bio::SeqIO->new(-format => $filetype, -file => '>'.$filebase.'_2P.'.$fileext);

# read input sequence file, determine forward or reverse, and write out to appropriate file
while(my $seqobj = $seqin->next_seq()) {
#	print $seqobj->desc . "\n";
	if ($seqobj->desc =~ /1:N:0:/) {
		$seqout1P->write_seq($seqobj);
	} elsif ($seqobj->desc =~ /2:N:0:/) {
		$seqout2P->write_seq($seqobj);
	} else {
		next;
	}
}
