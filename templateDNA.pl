#!/usr/bin/perl
use warnings;
use strict;

while (1) {
	print "Enter the uM of the DNA (or 'q' to quit): ";
	chomp(my $uM = <STDIN>);
	last if $uM eq 'q';
	print "Enter desired ng: ";
	chomp(my $ng = <STDIN>);
	my $ul = $ng / $uM;
	printf "Add %g ul of DNA soln.\n", $ul;
}
print "Bye!";
