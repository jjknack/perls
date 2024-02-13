#!/usr/bin/perl
# use the same plan for resolving duplicates to find pings to the same model in paired reads
# inputs: two comma-delimited table files from cmsearch using the same model,
# one forward and one reverse
# outputs a list of paired ends that ping to the model in question, with the forward score,
# reverse score, and combined score.
# by jjknack

use strict;
use warnings;

# open files
open(INPUT1, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
open(INPUT2, '<', $ARGV[1])
	or die "Cannot open input file: $!\n";
my ($filebase,$model) = ($1,$2) if $ARGV[0] =~ /(.+)_1P\.(RF\d{5})\.csv/;
my $model2 = $1 if $ARGV[1] =~ /.+_2P\.(RF\d{5})\.csv/;
die "Please input tables for the same model.\n" if $model ne $model2;
open(OUTPUT, '>', $filebase.'.'.$model."_pairedlist.txt")
	or die "Cannot open output file: $!\n";

# create some hash
my (%forward,%reverse);
while (<INPUT1>) {
	if ($_ =~ /(.+),-,.+,.+,cm,\d+,\d+,\d+,\d+,.+,.+,\d,.+,.+,(.+),.+,.+,.+/) {
		my ($target_name,$score) = ($1,$2);
#		print "$target_name\t$score\n";
		next if (exists $forward{$target_name} && $forward{$target_name} >= $score);
		$forward{$target_name} = $score;
	} else {
		next;
	}
}
close INPUT1;
while (<INPUT2>) {
	if ($_ =~ /(.+),-,.+,.+,cm,\d+,\d+,\d+,\d+,.+,.+,\d,.+,.+,(.+),.+,.+,.+/) {
		my ($target_name,$score) = ($1,$2);
#		print "$target_name\t$score\n";
		next if (exists $reverse{$target_name} && $reverse{$target_name} >= $score);
		$reverse{$target_name} = $score;
	} else {
		next;
	}
}
close INPUT2;

# compare the two models
print OUTPUT "NAME\tMODEL\tFORWARD_SCORE\tREVERSE_SCORE\tCOMBINED_SCORE\n";
foreach my $target (keys %forward) {
#	print "$target => $forward{$target}\n";
	if (exists $reverse{$target}) {
		my $combinedscore = $forward{$target} + $reverse{$target};
		printf OUTPUT ("%s\t%s\t%.1f\t%.1f\t%.1f\n", $target,$model,$forward{$target},$reverse{$target},$combinedscore);
	} else {
		next;
	}
}
close OUTPUT;
