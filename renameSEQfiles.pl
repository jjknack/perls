#!/usr/bin/perl
# written by jjknack
# renames a directory of misformatted SEQ files to the proper nomenclature
#  must be run from directory with SEQ files

use strict;
use warnings;

# Get list of SEQ files
system "ls -1 SEQ* > list.temp";
open(LIST, '<', "list.temp") or
	die "Cannot read list of SEQ files: $!\n";

# Loop through list.temp, search for improper file names, and fix them
while (<LIST>) {
	chomp;
	next if m/^SEQ\d+_SID\d+\.fasta$/; 
	if ($_ =~ m/^SEQ(\d+)_*SID(\d+).*\.f/i) {
		my $newname = "SEQ$1" . "_" . "SID$2" . ".fasta";
		#print "$_ --> $newname\n"
		system "mv $_ $newname";
	} else {
		next;
	}
}
close LIST;
system "rm list.temp";
