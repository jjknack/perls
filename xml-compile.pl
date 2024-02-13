#!/usr/bin/perl
# Description: Helper scripts used to initiate XML::Compile's proxys (WSDL+XSD)
# Author: Peter Fischer Hallin
# Email: pfh@cbs.dtu.dk
# Version: NA
# Date: 2008-02-13

use strict;
use XML::Compile;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MIME::Base64;
use URI::WithBase;


sub addOperations {
	# builds a hash of all operations declared in the proxy
	my ( $proxy , @OP )  = @_;
	# @OP is an optional list of operations to compile. All will be compiled inless defined
	my %ops;
	my %inc;
	if ( $#OP >= 0) {
		foreach (@OP) {
			$inc{$_} = 1;
		}
	}
	foreach my $op ($proxy->operations) {
		next if $#OP >= 0 and ! defined $inc{$op->{operation}};
		print STDERR "# compiling $op->{operation} ... \n";
		$ops{$op->{operation}} = $proxy->compileClient($op->{operation});
	}
	return %ops;
}

sub WSDL2proxy {
	# loads a WSDL and returns its proxy
	my $wsdl = XML::LibXML->new->parse_file($_[0]);
	my $proxy = XML::Compile::WSDL11->new($wsdl);
	return $proxy;
}

sub appendSchemas {
	# you have to manually check which external schemas are included in
	# your WSDL - this function will append them to the proxy for you
	my ($proxy , @schemas) = @_;
	foreach my $s (@schemas) {
		my $f = XML::LibXML->new->parse_file($s);
		$proxy->schemas->importDefinitions ($f);
	}
	return $proxy;
}

sub wait_job {
	my ($op_handle,$jobid) = @_;
	my $sleep = 0;
	print STDERR "# polling job $jobid\n";
	my $status = "UNKNOWN";
	my $response;
	while ( $status !~ /FINISHED|FAILED/ ) {
		$response = $op_handle->( job => { job  => { jobid => $jobid }   }) ;
		my $new_status = $response->{queueentry}->{queueentry}->{status};
		if ( $new_status ne $status ) {
			print STDERR "# job $jobid $new_status ($response->{queueentry}->{queueentry}->{datetime})\n";
			$status = $new_status;
		}
		$sleep = 5 if $status eq "ACTIVE";
		sleep $sleep;
	}
	die "# ERROR: job $jobid FAILED\n" if $status ne "FINISHED";
}

# with time, this is to replace the above functions!

sub WSDLclient {
	# by hhs 2008
	my ($wsdlurl, @ops)=@_;
	my %imports=();	
	my $importcnt;
	my %ops;
	my $wsdl = XML::LibXML->new->parse_file($wsdlurl);
	my $proxy = XML::Compile::WSDL11->new($wsdl);
		while (1) {
		foreach my $ns (keys %{$proxy->{schemas}->{namespaces} }) {
			foreach my $uri (keys %{$proxy->{schemas}->{namespaces}->{$ns}}) {
				foreach my $e (@{$proxy->{schemas}->{namespaces}->{$ns}->{$uri}}) {
					my $base = $wsdlurl;
					$base = $e->{filename} if defined $e->{filename};
					foreach my $ns2 (keys %{$e->{import}} ) {
						foreach my $fn ( @{$e->{import}->{$ns2}} ) {
							$uri = URI::WithBase->new($fn, $base);
							$imports{$uri->abs}=0 unless (defined $imports{$uri->abs});
						}
					}
				}
			}
		}
		$importcnt=0;
		foreach my $url (keys %imports) {
			next if $imports{$url} == 1; # added by pfh
			my $f = XML::LibXML->new->parse_file($url);
			$proxy->schemas->importDefinitions ($f);			
			$importcnt++;
			$imports{$url}=1;
		}
		last unless($importcnt);
	}

	my %inc;
	if ( $#ops >= 0) {
		foreach (@ops) {
			$inc{$_} = 1;
		}
	}
	foreach my $op ($proxy->operations) {
		next if $#ops >= 0 and ! defined $inc{$op->{operation}};
		$ops{$op->{operation}} = $proxy->compileClient($op->{operation});
	}

	return \%ops;	
}

1;

