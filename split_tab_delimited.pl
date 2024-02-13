#!usr/bin/perl
# split a large tab-delimited file into multiple files so that
# they may be opened in Excel (less than 1 million rows)
# argument: <input file>
use warnings;

# open input and first output file
open(INPUT, '<', $ARGV[0]) or
	die "Cannot open input file: $!\n";
$ARGV[0] =~ m/(.+)\.txt$/;
my $basename = $1;
my $outputcount = 0;
my ($OUTPUT, $outputfile) = create_output();
#print $OUTPUT;
#print $outputfile;
open($OUTPUT, '>', $outputfile) or
	die "Cannot open/create output file $outputcount: $!\n";
	
# read input and write to outputs
my $linecount = 0;
while (<INPUT>) {
	if ($linecount < 1000000) {
		print $OUTPUT "$_";
		$linecount++;
	} elsif ($linecount >= 1000000) {			# close old output and open new output
		close $OUTPUT;
		($OUTPUT, $outputfile) = create_output();
		open($OUTPUT, '>', $outputfile) or
			die "Cannot open/create output file $outputcount: $!\n";
		$linecount = 0;
		print $OUTPUT "$_";
		$linecount++;
	}
}
close INPUT;
close $OUTPUT;
		
# subroutine: create output tag and filename
sub create_output {
	$outputcount++;
	my $OUTPUT = 'OUTPUT' . $outputcount;
	my $outputfile = $basename . '_' . $outputcount . '.txt.';
	return ($OUTPUT, $outputfile);
}