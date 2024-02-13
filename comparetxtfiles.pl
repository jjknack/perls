#usr/bin/perl
#compare two text files and write any lines that are different
#by storing each line as an item in a list for each file (uses a lot of memory)
#by Jennifer Knack

use strict;
use warnings;

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

open(FILE1, '<', $file1) or
	die "Cannot open $file1: $!\n";
my @file1;
while (<FILE1>) {
	chomp;
	#print;
	push @file1, $_;
}
close FILE1;

open (FILE2, '<', $file2) or
	die "Cannot open $file2: $!\n";
my @file2;
while (<FILE2>) {
	chomp;
	#print;
	push @file2, $_;
}
close FILE2;

if (scalar @file1 != scalar @file2) {
	die "$file1 and $file2 are not the same length.\n";
}

open(OUTPUT, '>', 'comparison.txt') or
	die "Cannot open comparison.txt: $!\n";
my $length = scalar @file1;
my $arrayvalue = 0;
while ($arrayvalue < $length) {
	my $linenumber = $arrayvalue + 1;
	if ($file1[$arrayvalue] ne $file2[$arrayvalue]) {
		print OUTPUT "$linenumber\t$file1[$arrayvalue]\t$file2[$arrayvalue]\n";
	} else {
		print OUTPUT "$linenumber\tOK\n";
	}
	$arrayvalue++;
}
close OUTPUT;