#!/usr/bin/perl
# turn those dumb multi-space-delimited table files from cmsearch
# into comma-delimited files
# input is <file>
# by jjknack

use strict;
use warnings;

# open files
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
my $filebase = $1 if $ARGV[0] =~ /(.*).spacetbl/;
open(OUTPUT, '>', "$filebase.csv")
	or die "Cannot open output file: $!\n";

# do the changes
while (<INPUT>) {
	if (/^#target/) {
		s/#target name/target_name/;
		s/query name/query_name/;
		s/mdl from/mdl_from/;
		s/mdl to/mdl_to/;
		s/seq from/seq_from/;
		s/seq to/seq_to/;
		s/description of target/description_of_target/;
		s/\s+/,/g;
		s/,$//;
		print OUTPUT "$_\n";
	} elsif (/^#/) {
	} else {
		s/\s+/,/g;
		s/,$//;
		print OUTPUT "$_\n";
	}
}
close INPUT;
close OUTPUT;
