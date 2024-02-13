#!usr/bin/perl
#
#tree_name_list_maker_v1.1.pl
#
#Jonathan Klassen
#
#March 2, 2011
#April 18, 2011
#
#Replaces fasta header names with numbers, such that they can be fed into PHYLIP to make trees without losing information or creating duplicates
#Note: header capture regex is designed to find Pseudonocardia fasta headers. Mostly, designed to stop before the "/" that jalview inserts.
#Differs from v1 in that it captures all of the header information following the ">"

#useage $ perl tree_name_list_maker_v1.1.pl [input fasta file]

open (INFILE, $ARGV[0]) or die "Infile is not ARGV[0]";
($name = $ARGV[0]) =~ s/\..*$//;
open (OUTFILE1, ">$name\_names_replaced.fasta");
open (OUTFILE2, ">$name\_names.list");

while (<INFILE>){
	if (/^>(.+)$/){
		print "$1\n";
		push @names, $1;
		print OUTFILE1 ">_$#names\n";
		print OUTFILE2 "_$#names\t$names[$#names]\n";
	}
	else {
		print OUTFILE1 $_;
	}
}


