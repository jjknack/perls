#!/usr/bin/perl -w
# A perlscript written by Joseph Hughes, University of Glasgow
# use this perl script to split a multifasta file into user defined number of files
# Edited by Jen Knack for use with multifastq files


use strict;
use Getopt::Long; 
use Bio::SeqIO;


my ($fastq,$split,$help);
&GetOptions(
	    'in:s'      => \$fastq,#multifastqfile
	    's:s'   => \$split,#number of files to split it into
	    "help"  => \$help,  # provides help with usage
           );

# format: perl splitfastq.pl -in [filepath] -s [number of files to split into]
		   
my $in = Bio::SeqIO->new(-file => "$fastq" , '-format' => 'fastq');
my $grep="grep ".'">"'." $fastq |wc -l";
#print "$grep\n";
my $count=`$grep`;
#print "count $count\n";
my $seqsplit=$count/$split ;
#print "nb of sequences $seqsplit\n";
my $cntseq=0;
my $i=1;
my $filename=$fastq;
$filename=~s/(.+)\.(fastq)$/$1\_$i\.fastq/;
#print "$filename\n";
my $out = Bio::SeqIO->new(-file => ">$filename" , '-format' => 'fastq');
while ( my $seq = $in->next_seq() ) {
 $cntseq++;
 my $batch=$seqsplit*$i;
 #print "$cntseq $batch\n";
  if ($cntseq<=($seqsplit*$i)){
    $out->write_seq($seq);
  }else{
    $i++;
    $filename=$fastq;
    $filename=~s/(.+)\.(fastq)$/$1\_$i\.fastq/;
    $out = Bio::SeqIO->new(-file => ">$filename" , '-format' => 'fastq');
    $out->write_seq($seq);
  }
  
}