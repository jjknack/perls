#!/usr/bin/perl
# takes a combined REMOVE list from the outputs of resolvecmsearchduplicates.pl,
# puts that info into a hash, and then goes through the input afa file and if any
# read/model pairs are found, they are removed.  The rest are output to an afa file.
# input is <combined REMOVE list> <afa file>
# by jjknack

use strict;
use warnings;
use Bio::SeqIO;

# open REMOVE list
open(INPUT, '<', $ARGV[0])
	or die "Cannot open input file: $!\n";
$ARGV[1] =~ /^(.+)(RF\d{5})_dd\.afa$/
	or die "Please input an afa-formatted cmsearch output file.\n";
my ($filebase,$model) = ($1,$2);

# feed list into hash and close list
my %hash;
while (<INPUT>) {
	next unless m/^(.+)\t(RF\d{5})$/;
	my ($name,$listedmodel) = ($1,$2);
#	print "$name\t$listedmodel\n";
	if ($model eq $listedmodel) {
#		print "$model\t$listedmodel\n";
		$hash{$name} = 1;
	} else {
		next;
	}
}
#close INPUT;
#foreach my $key (keys %hash) {
#	print "$key\n";
#}

# open sequence files
my $seqin = Bio::SeqIO->new(-format => 'fasta', -file => $ARGV[1]);
my $seqout = Bio::SeqIO->new(-format => 'fasta', -file => '>'.$filebase.$model.'_scrubbed.afa');

# read input sequence file, compare to hash, and write out sequences not in hash
while(my $seqobj = $seqin->next_seq()) {
#	print $seqobj->display_id . "\n";
	next if exists $hash{$seqobj->display_id};
	$seqout->write_seq($seqobj);
}
