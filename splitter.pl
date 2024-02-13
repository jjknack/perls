#!/usr/bin/perl
# splitter.pl
# from http://bioinf-mac.uniandes.edu.co/biome/lrr/blog/?p=71
# modified so one can specify max number of seqs per file in ARGV by J. Knack
# argument: <input file> <max number of seqs per file>
use strict;
use Bio::SeqIO;

my ($file,$limit) = shift @ARGV;
my $seqIO = Bio::SeqIO->new(-file=>$file, -format=>"Fasta");
###my $limit = 100000;
my $j = 0;
my $seqO;
for(my $i=$limit+1; my $seq=$seqIO->next_seq(); $i++){
   if($i>=$limit){ $i=0;$seqO = Bio::SeqIO->new(file=>">$file.chomp".(++$j).".fasta", -format=>"Fasta")}
   $seqO->write_seq($seq);
}