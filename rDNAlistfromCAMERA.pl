#!usr/bin/perl
#read an CAMERA rDNA prediction output.1.seq file and
#create a list of headers of each type of rDNA sequence
#argument: <input file>
#by jjknack

use warnings;
use strict;

#open input file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";

#open output files
open(OUTPUTA16, '>', 'Archaeal16Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTA23, '>', 'Archaeal23Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTA5, '>', 'Archaeal5Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTB16, '>', 'Bacterial16Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTB23, '>', 'Bacterial23Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTB5, '>', 'Bacterial5Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTE28, '>', 'Eukaryotic28Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTE5, '>', 'Eukaryotic5Slist.txt')
	or die "Cannot create output file: $!\n";
open(OUTPUTE18, '>', 'Eukaryotic18Slist.txt')
	or die "Cannot create output file: $!\n";

#go through input and write each sequence to its corresponding file
while (<INPUT>) {
	if (m/^>(\S+).+Archaeal:16S_rRNA$/) {
		print OUTPUTA16 "$1.fasta\n";
	}
	if (m/^>(\S+).+Archaeal:23S_rRNA$/) {
		print OUTPUTA23 "$1.fasta\n";
	}
	if (m/^>(\S+).+Archaeal:5S_rRNA$/) {
		print OUTPUTA5 "$1.fasta\n";
	}
	if (m/^>(\S+).+Bacterial:16S_rRNA$/) {
		print OUTPUTB16 "$1.fasta\n";
	}
	if (m/^>(\S+).+Bacterial:23S_rRNA$/) {
		print OUTPUTB23 "$1.fasta\n";
	}
	if (m/^>(\S+).+Bacterial:5S_rRNA$/) {
		print OUTPUTB5 "$1.fasta\n";
	}
	if (m/^>(\S+).+Eukaryotic:28S_rRNA$/) {
		print OUTPUTE28 "$1.fasta\n";
	}
	if (m/^>(\S+).+Eukaryotic:5S_rRNA$/) {
		print OUTPUTE5 "$1.fasta\n";
	}
	if (m/^>(\S+).+Eukaryotic18S_rRNA$/) {	#the lack of colon is intentional
		print OUTPUTE18 "$1.fasta\n";
	}
}

#close it up
close INPUT;
close OUTPUTA16;
close OUTPUTA23;
close OUTPUTA5;
close OUTPUTB16;
close OUTPUTB23;
close OUTPUTB5;
close OUTPUTE28;
close OUTPUTE5;
close OUTPUTE18;