#!/usr/bin/perl
# find cmsearch pairs and smush them
# input is forward and reverse fasta files for same search
# by jjknack

use strict;
use warnings;
use Bio::Seq;
use Bio::SeqIO;

# store inputs
my ($Ffile,$Rfile) = @ARGV;
my ($Fbase,$Fmodel,$Rbase,$Rmodel);
if ($Ffile =~ /^(.+)_1P\.(.+)\.fasta/) {
	($Fbase,$Fmodel) = ($1,$2);
} else {
	die "Please input a valid forward fasta file\n";
}
if ($Rfile =~ /^(.+)_2P\.(.+)\.fasta/) {
	($Rbase,$Rmodel) = ($1,$2);
} else {
	die "Please input a valid reverse fasta file\n";
}
die "Please input two files for the same dataset\n" unless ($Fbase eq $Rbase);
die "Please input two files for the same model\n" unless ($Fmodel eq $Rmodel);

# create some hash
open(FORWARD,'<',$Ffile)
	or die "Cannot open $Ffile: $!\n";
open(REVERSE,'<',$Rfile)
	or die "Cannot open $Rfile: $!\n";
my (%forward,%reverse);
while (<FORWARD>) {
	if ($_ =~ /^>(\S+)\s.+/) {
		$forward{$1} = 1;
	} else {
		next;
	}
}
close FORWARD;
while (<REVERSE>) {
	if ($_ =~ /^>(\S+)\s.+/) {
		$reverse{$1} = 1;
	} else {
		next;
	}
}
close REVERSE;

# compare the two hashes to make a pair hash
my %pairs;
foreach my $target (keys %forward) {
#	print "$target => $forward{$target}\n";
	if (exists $reverse{$target}) {
		$pairs{$target} = 1;
	} else {
		next;
	}
}

# reopen inputs as seq files
my $Fseq = Bio::SeqIO->new(-format => 'fasta', -file => $Ffile);
my $Rseq = Bio::SeqIO->new(-format => 'fasta', -file => $Rfile);
my $seqout = Bio::SeqIO->new(-format => 'fasta', -file => '>'.$Fbase.'_1Psmush2P.'.$Fmodel.'.fasta');

# read forward sequence file, compare to hash, and do stuff
while(my $Fread = $Fseq->next_seq()) {
#	print $Fread->display_id . "\n";
	if (exists $pairs{$Fread->display_id}) {	#if the header is in the pairs hash
		while(my $Rread = $Rseq->next_seq()) {	#find it in reverse seqs
			next unless $Rread->display_id eq $Fread->display_id;
			my $revcomRread = $Rread->revcom();	#revcom it
			my $smushread = Bio::Seq->new(	-seq => $Fread->seq() . $revcomRread->seq(),
							-id => $Fread->display_id,
							-desc => 'smushed',
							);	#smush it to forward read
			$seqout->write_seq($smushread);	#write it out
			last;	#stop looking for the reverse read after you've found it
		}
	} else {	#otherwise, just write it in the new file
		$seqout->write_seq($Fread);
	}
}
# don't want to omit the reverse reads without a forward pair!
while(my $Rread = $Rseq->next_seq()) {
#	print $Rread->display_id . "\n";
	if (exists $pairs{$Rread->display_id}) {
		next;	#don't write it if it's already been taken care of by the previous step
	} else {
		$seqout->write_seq($Rread);
	}
}

# The End
