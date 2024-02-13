#!/usr/bin/perl
# Description: Client script in Perl (XML::Compile) running the RNAmmer Web Service
# Author: Karunakar Bayyapu
# Email: karun@cbs.dtu.dk
# Version: 1.2 ws1
# Date: 2012-04-23

### for installation and usage notes please see below

### client code starts here

use strict;
use warnings;
use XML::Compile;
use XML::Compile::SOAP11;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
$!=1;
eval{
   my $wsdlurl = 'http://www.cbs.dtu.dk/ws/RNAmmer/RNAmmer_1_2_ws1.wsdl';
   my $wsdl = XML::LibXML->new->parse_file($wsdlurl);
   my $proxy = XML::Compile::WSDL11->new($wsdl);
 
   my $xsd1 = parse_file("http://www.cbs.dtu.dk/ws/common/ws_common_1_0b.xsd");
   $proxy->importDefinitions ($xsd1);
  
   my $xsd2 = parse_file("http://www.cbs.dtu.dk/ws/RNAmmer/ws_rnammer_1_2_ws1.xsd");
   $proxy->importDefinitions ($xsd2);
 
#runService --You need to change the sequences and ids as per your requirement. 
	      #organism and method are optional as per wsdl document
  
   my $inSeq1 = <<EOF
MTEYKLVVVGAGGVGKSALTIQLIQNHFVDEYDPTIEDSYRKQVVIDGETCLLDILDTAG
QEEYSAMRDQYMRTGEGFLCVFAINNSKSFADINLYREQIKRVKDSDDVPMVLVGNKCDL
PTRTVDTKQAHELAKSYGIPFIETSAKTRQGVEDAFYTLVREIRQYRMKKLNSSDDGTQG
CMGLPCVVM
EOF
;

   my $inSeq2 = <<EOF
MNLSLVLAAFCLGIASAVPKFDQNLDTKWYQWKATHRRLYGANEEGWRRAVWEKNMKMIE
LHNGEYSQGKHGFTMAMNAFGDMTNEEFRQMMGCFRNQKFRKGKVFREPLFLDLPKSVDW
RKKGYVTPVKNQKQCGSCWAFSATGALEGQMFRKTGKLVSLSEQNLVDCSRPQGNQGCNG
EOF
;
	 
  my $runService = $proxy->compileClient("runService");
  my $parameters = { parameters => {sequencedata=>sequence=>
					[{id=>"IPI:IPI00000005.1", seq=> $inSeq1},
					{id=>"IPI:IPI00000013.1",seq=> $inSeq2}]
				   } 
                   };
  my %params = (parameters => $parameters);
  my ($answer, $trace) = $runService->(%params);
  $trace->printRequest;
  $trace->printResponse;
  
#pollQueue  --jobid needs to be changed as which you got from runService
 
  my $param={job => {jobid => '73460972-36DE-11E1-BC9D-A1BF56C4AF00'}};
  my %params = (job => $param);
  my ($answer, $trace) = $proxy->compileClient('pollQueue')->(%params) ;   
  $trace->printRequest;		
  $trace->printResponse;

#fetchResults  --jobid needs to be changed as which you got from runServices
 
  my ($answer, $trace) = $proxy->compileClient('fetchResult')->
	                   ({job => {jobid => '73460972-36DE-11E1-BC9D-A1BF56C4AF00'}}) ;   
  $trace->printRequest;  
  $trace->printResponse;
 
 };
 if ($@){
        print "Caught an exception:$!\n";
       exit 1;
       }
 1;

### client code ends here

#########################################################################################
#############################				    #############################
#############################          DOCUMENTATION        #############################
#############################          			    #############################
#########################################################################################

#	Introduction:

#		XML::Compile::SOAP is to access the web service. XML::Compile::SOAP(CPAN) 
#		requires XML::LibXML(CPAN) which uses the libxml2 library, depending on 
#		your system requirements and you may have to install this separately.

#	Installation:

#		Required/Tested Version: Perl v5.10 and XML:.Compile -v 1.22

#		The XML::Compile::SOAP modules can be installed by:
#		1. Using CPAN to install XML::Compile::SOAP (CPAN).
#		2. Downloading the XML::Compile::SOAP distribution and installing manually:
#		     from CPAN
#		     from http://perl.overmeer.net/xml-compile/


#	Access Web sevices:

#		In Document/literal SOAP services all messages are described using complex types. 
#		Thus to use any operation on a document/literal service the message has to be defined. 
#		In XML::Compile::SOAP (CPAN) the message data is represented as a nested hash, which 
#		is mapped into the actual XML to be sent by XML::Compile using the XML schema information
#		provided in the WSDL or imported separately.

#	NOTE: We imported xsd's manually since XML::Compile library is unable to import XSds 
#		automatically. So we import two xsds of wsdl.

#		Ths RNAmmer service code access to see one method results at once. If you would like to 
#		see runService method results then you would need to comment the rest of the methods code 
#		and for rest also same. In the runService, you need to submit required fileds like one id 
#		and corresponding sequence or more ids and their corresponding sequences as a input(STDIN) 
#		data to convert FASTA format to get the results.
#		For input data/FASTA format see example: 
#			http://www.cbs.dtu.dk/ws/RNAmmer/examples/example)

#		After getting jobid from runService then you would need to submit jobid in the pollQueue 
#		to know the status of the job. After knowing the status of the job from pollQueue then 
#		you need to submit jobid in the fetchResult to see complete final results. 
#		It means you can only see final results in the fetchResult since RNAmmer is implemented 
#		in asynchronous way

#	Compile:

#		after writing above client code in your editor and save it as client.pl and run with 
#		this command on your Linux cmd, before running you make sure that you are in same directory. 

#		>./client.pl
  
#	Result:

#		We can see SOAP 'Request' and SOAP 'Response' at the same time from this code since we are 
#		tracing input and output for detailed information. The Request and Result are should be in 
#		SOAP format because web service works with only XML data. For every job request the jobdid 
#		will be changed and rest are same for this service. 
