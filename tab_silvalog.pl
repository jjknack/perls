#!/usr/bin/perl
# converts a silva log file to the Read,Class,Score format:
# <sequence_identifier>\t<lca_tax_slv>\t<arbitrary score since log file no longer has one>\n
# input is <file>.log
# by jjknack

use strict;
use warnings;

# open files
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
my $filebase = $1 if $ARGV[0] =~ /(.*).log/;
open(OUTPUT, '>', "$filebase.tab")
	or die "Cannot open output file: $!\n";

# do the changes
while (<INPUT>) {
	chomp $_;
	if ( /^sequence_identifier: (.+)$/ ) {
		print OUTPUT "$1\t";
	} elsif ( /^lca_tax_slv: (.+)$/ ) {
		print OUTPUT "$1\t100\n";
	} else {
		next;
	}
}
close INPUT;
close OUTPUT;
