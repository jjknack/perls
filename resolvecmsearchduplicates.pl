#!/usr/bin/perl
# maybe I can use crazy data structures to try and solve this duplicate problem
# inputs: two comma-delimited table files from cmsearch
# outputs a list of ping/model to REMOVE
# by jjknack

use strict;
use warnings;

# open files
open(INPUT1, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
open(INPUT2, '<', $ARGV[1])
	or die "Cannot open input file: $!\n";
my $in1 = $1 if $ARGV[0] =~ /(.+)\.csv/;
my $in2 = $1 if $ARGV[1] =~ /(.+)\.csv/;
open(OUTPUT, '>', "REMOVE_".$in1.'_'.$in2.".txt")
	or die "Cannot open output file: $!\n";

# create some data structures
my (@models,%forward,%reverse);
while (<INPUT1>) {
	if ($_ =~ /(.+),-,.+,(.+),cm,\d+,\d+,\d+,\d+,.+,.+,\d,.+,.+,(.+),.+,.+,.+/) {
		my ($read,$model,$score) = ($1,$2,$3);
		$models[0] = $model unless defined $models[0];
		next if (exists $forward{$read} && $forward{$read} >= $score);
		$forward{$read} = $score;
	} else {
		next;
	}
}
close INPUT1;
while (<INPUT2>) {
	if ($_ =~ /(.+),-,.+,(.+),cm,\d+,\d+,\d+,\d+,.+,.+,\d,.+,.+,(.+),.+,.+,.+/) {
		my ($read,$model,$score) = ($1,$2,$3);
		$models[1] = $model unless defined $models[1];
		next if (exists $reverse{$read} && $reverse{$read} >= $score);
		$reverse{$read} = $score;
	} else {
		next;
	}
}
close INPUT2;
#print join(", ", @models);

# compare the two models
foreach my $target (keys %forward) {
#	print "$target => $forward{$target}\n";
	if (exists $reverse{$target}) {
#		print "$forward{$target}\t$reverse{$target}\n";
		if ($forward{$target} < $reverse{$target}) {
			print OUTPUT "$target\t$models[0]\n";
		} else {
			print OUTPUT "$target\t$models[1]\n";
		}
	} else {
		next;
	}
}
close OUTPUT;
