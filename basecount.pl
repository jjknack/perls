#!usr/bin/perl
# Count the number of bases in a multifasta file and print the count into stout
# argument: <input file>
# by jjknack

use warnings;
use strict;

my $bases = 0;

# open input file
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";

# go through input, count the length of each sequence, and add to $bases
while (<INPUT>) {
	if (m/^>/) {
		next;
	} else {
		$bases++ while(m/[A-Z,a-z]/g);
	}
}

# close it up
close INPUT;

# print output to STOUT
print "There are $bases bases in $ARGV[0].\n";