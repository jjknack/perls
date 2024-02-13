#!usr/bin/perl
#
#tree_name_replacer_v1.2.pl
#
#Jonathan Klassen
#
#April 18, 2011
#
#Works with tree_name_list_maker.pl
#Replaces "_[number]" names in the newick file with their corresponding sequence names.
#Differs from v1 in that the name accepted is more general
#usage: perl tree_name_replacer_v1.2.pl [input tree file] [input lookup table, typically *_names.list (but it doesn't matter)] [output file name]

open INTREE, $ARGV[0] or die "Input tree is not ARGV[0]";
open INLIST, $ARGV[1] or die "Input tree is not ARGV[1]";
open OUTFILE, ">$ARGV[2]" or die "Output file is not ARGV[2]";

while (<INLIST>){
	/(_\d+)\t(.+)/ or die "Cannot match INLIST data";
	$temp = $1;
	$names{$temp} = $2;
	$names{$temp} =~ s/,|://g;
	$names{$temp} =~ s/\(/[/g;
	$names{$temp} =~ s/\)/]/g;
}
foreach $a (sort keys %names){
	print "$a\t$names{$a}\n";
}
while (<INTREE>){
	s/(_\d+)/$names{$1}/g;
	print OUTFILE;
}
