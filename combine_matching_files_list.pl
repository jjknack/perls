#!/usr/bin/perl
#written by jjknack
#reads a list of file names, checks each for match of a UNIQUE LIST OF ITEMS, and writes contents of matching files to one output file
#argument order: <list of files> <output file name> <list of items>

use strict;
use warnings;

#create hash of item list
open(ITEMLIST, '<', $ARGV[2]) or
	die "Cannot open item list: $!\n";
my %itemlist;
while (<ITEMLIST>) {
	next unless ($_ =~ m/^(\w+)\s/);
	$itemlist{$1} = 1;
}
close ITEMLIST;

#compare hash to file list and write matches to output
open(FILELIST, '<', $ARGV[0]) or
	die "Cannot open file list: $!\n";
open(OUTPUT, '>>', $ARGV[1]) or
	die "Cannot open output: $!\n";
while (<FILELIST>) {
	next unless ($_ =~ m/^(\w+)/);
	my $seqname = uc $1;
	if (exists $itemlist{$seqname}) {
		write_contents_to_output($_);
	}
}
close FILELIST;
close OUTPUT;

sub write_contents_to_output {
	my $filename = shift;
	chomp $filename;
	open(INPUT, '<', $filename) or
		die "Cannot open input file $filename: $!\n";
	while (<INPUT>) {
		print OUTPUT $_;
	}
	close INPUT;
	return;
}