# !/usr/bin/perl
# written by Jennack
# INCOMPLETE
# split large multi-fasta files into many smaller ones

use warnings;
use strict;
use File::Temp 'tempfile';

my $file = $ARGV[0];
unless (-f $file) {
	die "No file specified\n";
}
$file =~ /(.*)\..*/;
my $filebase = $1;
#print $filebase;

my $n = $ARGV[1];
$n =~ /^\d+$/ or die "No integer value specified\n";
#print $n;

#my $i = 1;
#open (INPUT, $file) or die "Could not open file\n";
#while (1) {
#	my $string = read_n_fastas($n);
#	write_file($string);
#}	

sub read_n_fastas {
	my $n = $_;
	my $x = 0;
	my $string;
	while ($x < $n) {
		
	#read n fastas to a string
	#return string
}

sub write_file {
	#write the string from read_n_fastas to $filebase_$i.fasta;
	#$i++;
	#return 0;
}