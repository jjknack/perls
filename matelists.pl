#!/usr/bin/perl
# read two lists of headers from different cmsearch results and looks
# for duplicates (reads that were pinged in both searches)
# so the user can check each ping and determine which hit is real
# inputs are <list 1> and <list 2>
# by jjknack

use warnings;
use strict;

# open files
open(INPUT1, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
open(INPUT2, '<', $ARGV[1])
	or die "Cannot open input file: $!\n";
my $in1 = $1 if $ARGV[0] =~ /(.*)list.txt/;
my $in2 = $1 if $ARGV[1] =~ /(.*)list.txt/;
open(OUTPUT, '>', $in1."mate".$in2.".txt")
	or die "Cannot open output file: $!\n";

# read first list into a hash
my %keys;
while (<INPUT1>) {
	$keys{$_} = 1;
}
close INPUT1;

# check second list against hash
while (<INPUT2>) {
	print OUTPUT $_ if exists $keys{$_};
}
close INPUT2;
close OUTPUT;
