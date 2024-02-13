#!/usr/bin/perl
# read an INFERNAL cmsearch output text (not alignment) file and
# create a list of headers for each type of sequence (rDNA in this case)
# argument: <input file>
# INCOMPLETE
# by jjknack

use warnings;
use strict;

# open input file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";

# open output files
open(OUTPUT5S, '>', '5Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUT5_8S, '>', '5.8Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTSSUBACT, '>', 'BacteriaSSUlist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTSSUARCH, '>', 'ArchaeaSSUlist.txt')
	or die "Cannot create output file: $!\n";
#open(OUTPUTxxx, '>', 'xxxlist.txt')
	or die "Cannot create output file: $!\n";
#open(OUTPUTxxx, '>', 'xxxlist.txt')
	or die "Cannot create output file: $!\n";
#open(OUTPUTxxx, '>', 'xxxlist.txt')
	or die "Cannot create output file: $!\n";
#open(OUTPUTxxx, '>', 'xxxlist.txt')
	or die "Cannot create output file: $!\n";
#open(OUTPUTxxx, '>', 'xxxlist.txt')
	or die "Cannot create output file: $!\n";

# go through input and write each sequence to its corresponding file
#while (<INPUT>) {
#	if (m/^>(\S+).+Archaeal:16S_rRNA$/) {
#		print OUTPUTA16 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Archaeal:23S_rRNA$/) {
#		print OUTPUTA23 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Archaeal:5S_rRNA$/) {
#		print OUTPUTA5 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Bacterial:16S_rRNA$/) {
#		print OUTPUTB16 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Bacterial:23S_rRNA$/) {
#		print OUTPUTB23 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Bacterial:5S_rRNA$/) {
#		print OUTPUTB5 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Eukaryotic:28S_rRNA$/) {
#		print OUTPUTE28 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Eukaryotic:5S_rRNA$/) {
#		print OUTPUTE5 "$1.fasta\n";
#	}
#	if (m/^>(\S+).+Eukaryotic18S_rRNA$/) {	the lack of colon is intentional
#		print OUTPUTE18 "$1.fasta\n";
#	}
#}

# close it up
close INPUT;
close OUTPUT5S;
close OUTPUT5_8S;
close OUTPUTSSUBACT;
close OUTPUTSSUARCH;
#close OUTPUTB23;
#close OUTPUT58S;
#close OUTPUTE28;
#close OUTPUTMICRO16;
#close OUTPUTE18;
