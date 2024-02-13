#!/usr/bin/perl
# written by jjknack
# reads a list of file names, checks each for match of a REGEX ARGUMENT, and writes contents of matching files to one output file

use strict;
use warnings;

my $regex = $ARGV[2];
open(LIST, '<', $ARGV[0]) or
	die "Cannot open list: $!\n";
open(OUTPUT, '>>', $ARGV[1]) or
	die "Cannot open output: $!\n";

while (<LIST>) {
	if ($_ =~ m/$regex/i) {
		write_contents_to_output($_);
	}
}

close LIST;
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
