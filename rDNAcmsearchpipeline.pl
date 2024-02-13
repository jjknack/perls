#!/usr/bin/perl
# here's a pipeline for using INFERNAL to find rDNA in a multifasta file.
# assumes you have each RF as a separate cm file, all in the home directory.
# also assumes the path to your Perl scripts is in Dropbox (change if necessary)
# script designed for use with INFERNAL 1.1.1 and Rfam 12.0
# input is <multifasta file> and
# <index number of @rDNAcms where you wish to start the script> (optional) and
# <index number of @rDNAcms where you wish to end the script> (optional).
# by jjknack

use warnings;
use strict;

my $home = "/home/jjknack";
my $scriptslocation = "$home/Dropbox/Scripts";
my $infilebase = $1 if $ARGV[0] =~ /(.*)\.f.+/;
my ($startindex, $endindex);
if (exists $ARGV[1] && $ARGV[1] <= 8) {
	$startindex = $ARGV[1];
} else {
	$startindex = 0;
}
if (exists $ARGV[2] && $ARGV[2] >= $startindex && $ARGV[2] <= 8) {
	$endindex = $ARGV[2];
} else {
	$endindex = 8;
}
#print "$infilebase\n";
my @rDNAcms = ("RF00001", "RF00002", "RF00177", "RF01959", "RF02542", "RF01960", "RF02540", "RF02541", "RF02543");

foreach my $index ($startindex..$endindex) {
	my @cmsearch = ("cmsearch", "-o", "$infilebase.$rDNAcms[$index].txt", "-A", "$infilebase.$rDNAcms[$index].pfam", "--tblout", "$infilebase.$rDNAcms[$index].spacetbl", "--notextw", "--verbose", "--anytrunc", "--mxsize", "6000", "--tformat", "fasta", "--cpu", "2", "$home/$rDNAcms[$index].cm", $ARGV[0]);
#	print join("\n", @cmsearch);
	print "Running cmsearch with $rDNAcms[$index]...\n";
	system(@cmsearch) == 0		# perform the cmsearch
		or die "system cmsearch $rDNAcms[$index] failed: $?\n";
	print "cmsearch $rDNAcms[$index] completed successfully.  Converting table to csv format...\n";
	my @perl = ("perl", "$scriptslocation/cmsearchspacetbltocsv.pl", "$infilebase.$rDNAcms[$index].spacetbl");
	system(@perl) == 0		# perform the conversion of the spacetbl to csv
		or die "system Perl script cmsearchspacetbltocsv.pl failed: $?\n";
	system("rm", "$infilebase.$rDNAcms[$index].spacetbl");
	print "Perl script cmsearchspacetbltocsv.pl completed successfully.  Now running esl-reformat on output pfam alignment...\n";
	my @reformat = ("esl-reformat", "-d", "-o", "$infilebase.$rDNAcms[$index].afa", "--gapsym=-", "--small", "--informat", "pfam", "afa", "$infilebase.$rDNAcms[$index].pfam");
#	print join("\n", @reformat);
	system(@reformat) == 0		# perform esl-reformat from pfam to afa
		or die "system esl-reformat of $infilebase.$rDNAcms[$index].pfam failed: $?\n";
	print "esl-reformat of $infilebase.$rDNAcms[$index].pfam completed successfully\n";
}
print "Pipeline successfully completed for $ARGV[0]\n";


#foreach my $RF (@rDNAcms) {
#	my @cmsearch = ("cmsearch", "-o", "$infilebase.$RF.txt", "-A", "$infilebase.$RF.pfam", "--tblout", "$infilebase.$RF.csv", "--notextw", "--verbose", "--anytrunc", "--mxsize", "2500", "--tformat", "fasta", "--cpu", "6", "/home/jjknack/$RF.cm", $ARGV[0]);
##	print join("\n", @cmsearch);
#	print "Running cmsearch with $RF...\n";
#	system(@cmsearch) == 0
#		or die "system cmsearch $RF failed: $?, $!\n";
#	print "cmsearch $RF completed successfully.  Now running esl-reformat on output pfam alignment...\n";
#	my @reformat = ("esl-reformat", "-d", "-o", "$infilebase.$RF.fasta", "--gapsym=-", "--small", "--informat", "pfam", "afa", "$infilebase.$RF.pfam");
##	print join("\n", @reformat);
#	system(@reformat) == 0
#		or die "system esl-reformat of $infilebase.$RF.pfam failed: $?, $!\n";
#	print "esl-reformat of $infilebase.$RF.pfam completed successfully\n";
#}
#print "Pipeline successfully completed for $ARGV[0]\n";
