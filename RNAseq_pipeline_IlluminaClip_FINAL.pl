#!/usr/bin/perl -w
# Written by AJ Book
# Edited for use by JJ Knack
#  Requires SamTools, BamTools, BWA, Java, and Trimmomatic

use strict;
# Place all fastq files from the same strain in a folder together and name it on strain (runxxx_ActE)
# Modify $subdir to be runxxx_ActE
# Modify $reference to be correct reference genome
# Save modified script into runxxx_ActE folder
# Useage move into runxxx_ActE folder execute $ perl RNAseq_SE_pipeline_AB.pl > acte_rnaseq_cmd.sh

my $trim = 1;
my $align = 1;
my $indexbam = 1;
my $clean = 1;
my $path = '..';
my $outpath = '..';
my @subdirs = qw( 
griseus
);
my @files = qw(
);

# Possible additional inputs
my $reference = '/home/adam/RNAseq_genome_refs/Strep_griseus/NC_010572.fna'; # modify with correct path to correct reference	# modified by jjknack
my $adapter_seq ='/home/adam/RNAseq_genome_refs/Illumina_adapter_seq.fasta';	#modified by jjknack

my @inputs;
foreach my $d (@subdirs) {
  if (@files) {
    foreach my $f (@files) {
       push @inputs, glob("$path/$d/$f");
    }
  }
  else {
      push @inputs, glob("$path/$d/*.fastq");
  }
}

sub docmd {
    my($cmd) = @_;
    print "$cmd\n";
    # print `$cmd`;
}

foreach my $input (@inputs) {

    my $dirname = $input;
    my $filename = $input;
    $dirname =~ s!^(.*/)[^/]*$!\1!;
    $filename =~ s!^.*/([^/]*)$!\1!;
    print "\n\n# working on $input $dirname $filename\n"; 

    my $prefix;
    if($filename =~ /(.*).fastq/) {
      $prefix = $1;
    } else {
      print "Can't parse $filename.";
      exit 1;
    }
    my $out_prefix = $dirname.$prefix;
    $out_prefix =~ s/$path/$outpath/;

    # To separate paired end
    #docmd("~/bin/separatePairedEnds_v2.pl $input");

    my $trimfastq=$out_prefix."_trim.fastq";
    my $saifile=$out_prefix."_bwa.sai";
    my $samfile=$out_prefix."_bwa.sam";
    my $bamfile=$out_prefix."_bwa.bam";
    my $sortedbamfile=$out_prefix."_bwa_sort";
    my $indexbaminput=$out_prefix."_bwa_sort.bam";
    my $bamfile_stats=$out_prefix."_bwa_bam_stats.txt";
    my $cmd="bwa aln -t 15 $reference $trimfastq > $saifile";
    my $trim="TrimmomaticSE -threads 15 -phred33 $input $trimfastq ILLUMINACLIP:$adapter_seq:2:40:15 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:60";	# modified by jjknack
    # To trim
    if ($trim) {
      docmd($trim);
    }
    # To align
    if ($align) {
      docmd($cmd);  # bwa
    }
    if ($indexbam) {
      # To convert from sai to sam
      docmd("bwa samse $reference $saifile $trimfastq > $samfile");
      
      # To convert from sam to bam 
      docmd("samtools view -bS $samfile -o $bamfile");

      # To sort
      docmd("samtools sort $bamfile $sortedbamfile"); 

      # To index
      docmd("samtools index $indexbaminput");
      
      # To calculate stats
      docmd("bamtools stats -in $bamfile > $bamfile_stats");	#modified by jjknack

    }
}
{    if ($clean) {

     docmd("more *stats.txt > griseus_stats.txt");

     docmd("rm -f *.sam");

     docmd("rm -f *.sai");

     docmd("rm -f *trim.fastq");
	
    }

}
