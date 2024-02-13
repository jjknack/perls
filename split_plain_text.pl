#!/usr/bin/perl
#written by Jennack
#split large text files into smaller ones based on size
#arguments: <input file> <max file size>

use warnings;

# open input and first output file
open(INPUT, '<', $ARGV[0]) or
	die "Cannot open input file: $!\n";
$ARGV[0] =~ m/(\w+)\.(\w+)$/;
my $basename = $1;
my $filetype = $2;
my $outputcount = 0;
my ($OUTPUT, $outputfile) = create_output();
#print $OUTPUT;
#print $outputfile;
open($OUTPUT, '>', $outputfile) or
	die "Cannot open/create output file $outputcount: $!\n";
	
# convert desired maximum file size into bytes
$ARGV[1] =~ m/^(\d+\.?\d*)\s?([k|m|g]b)$/i;
my $sizenumber = $1;
my $sizeunits = $2;
my $maxfilesize;
if ($sizeunits =~ m/kb/i) {
	$maxfilesize = $sizenumber * 1024;
} elsif ($sizeunits =~ m/mb/i) {
	$maxfilesize = $sizenumber * 1048576;
} elsif ($sizeunits =~ m/gb/i) {
	$maxfilesize = $sizenumber * 1073741824;
} else {
	die "Improperly formatted maximum size given.\n";
}

# read input and write to outputs
while (<INPUT>) {
	if (-s $outputfile < $maxfilesize) {
		print $OUTPUT "$_";
	} elsif (-s $outputfile >= $maxfilesize) {			# close old output and open new output
		close $OUTPUT;
		($OUTPUT, $outputfile) = create_output();
		open($OUTPUT, '>', $outputfile) or
			die "Cannot open/create output file $outputcount: $!\n";
		print $OUTPUT "$_";
	}
}
close INPUT;
close $OUTPUT;
	
# subroutine: create output tag and filename
sub create_output {
	$outputcount++;
	my $OUTPUT = 'OUTPUT' . $outputcount;
	my $outputfile = $basename . "_" . $outputcount . "." . $filetype;
	return ($OUTPUT, $outputfile);
}