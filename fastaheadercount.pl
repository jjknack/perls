#!/usr/bin/perl
# check multifasta file for repeat fasta headers using hash (uses a lot of memory)
# command line argument is <input file>
# by Jennifer Knack

use strict;
use warnings;

open(INPUT, '<', $ARGV[0]) or
	die "Cannot open $ARGV[0]: $!\n";

my %headers;
while (<INPUT>) {
	if (m/^>(.+)/) {
		my $header = $1;
		chomp($header);
		if (exists $headers{$header}) {
			$headers{$header}++;
		} else {
			$headers{$header} = 1;
		}
	} else {
		next;
	}
}

close INPUT;
open(OUTPUT, '>', "headerlist.txt") or
	die "Cannot open headerlist.txt: $!\n";

while (my ($key, $value) = each %headers) {
	print OUTPUT "$key => $value\n";
}
close OUTPUT;
