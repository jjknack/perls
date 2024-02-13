#!/usr/bin/perl
# searches a csv file from cmsearch, finds duplicate pings for a read and
# remembers which ones scored lowest, then scrubs the corresponding afa file
# of those lower-scoring pings
# MAKE SURE THE CSV LIST IS SORTED HIGHEST-SCORING TO LOWEST
# input: the shared file name (without file extension) of the csv and afa file
# outputs the de-duplicated afa file
# by jjknack

use strict;
use warnings;
use Bio::SeqIO;

# open csv file
my $filebase = $ARGV[0];
open(CSV, '<', "$filebase.csv")
	or die "Cannot open input file: $!\n";

# create some data structures
my (%scores,%trashheaders);
print "Preparing to remove the following reads:\n";
while (<CSV>) {
	if ($_ =~ /(.+),-,.+,.+,cm,\d+,\d+,(\d+),(\d+),.+,.+,\d,.+,.+,(.+),.+,(\?|!),.+/) {
		my ($read,$from,$to,$score,$sig) = ($1,$2,$3,$4,$5);
		next if $sig eq "?";
		next if $read =~ /^k/;		# to exclude contigs from the analysis
		if (exists $scores{$read}) {
#			print "$read\n";
			if ($scores{$read} >= $score) {
				my $header = "$read/$from-$to";
				$trashheaders{$header} = 1;
				print "\t$header\n";
			} elsif ($scores{$read} < $score) {
				die "MAKE SURE THE CSV LIST IS SORTED HIGHEST-SCORING TO LOWEST\n";
			}
		} else {
			$scores{$read} = $score;
		}
	} else {
		next;
	}
}
close CSV;

# open seq files
my $seqin = Bio::SeqIO->new(-format => 'fasta', -file => $filebase.'.afa');
my $seqout = Bio::SeqIO->new(-format => 'fasta', -file => '>'.$filebase.'_dd.afa');

# read input sequence file, compare to hash, and write out sequences not in hash
while(my $seqobj = $seqin->next_seq()) {
#	print $seqobj->display_id . "\n";
	next if exists $trashheaders{$seqobj->display_id};
	$seqout->write_seq($seqobj);
}
