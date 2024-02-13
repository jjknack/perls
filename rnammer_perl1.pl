#!/usr/bin/perl
# Description: Client script in Perl (SOAP::Lite) running the RNAmmer Web Service
# Author: Karunakar Bayyapu
# Email: karun@cbs.dtu.dk
# Version: 1.2 ws1
# Date: 2012-04-23

### for installation and usage notes please see below

### client code starts here

use Data::Dumper;
use SOAP::Lite 'trace', 'debug';
my $wsdl='http://www.cbs.dtu.dk/ws/RNAmmer/RNAmmer_1_2_ws1.wsdl';
my $proxy='http://wss.cbs.dtu.dk:80/cgi-bin/soap/ws/quasi.fcgi';
my $soap=SOAP::Lite
         ->uri($wsdl)
	 ->proxy($proxy)
	 ->readable(1);
	 
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
			
my $params = SOAP::Data->name("parameters" =>
                               \SOAP::Data->value(
	                            SOAP::Data->name("sequencedata"=>
                             		\SOAP::Data->value(
		           	 		SOAP::Data->name("sequence" =>
				 			\SOAP::Data->value( 
				      				 SOAP::Data->type('')->name("id")->value('HUMAN2'),
				       				 SOAP::Data->type('')->name("seq")->value("$inSeq1"),
								 SOAP::Data->type('')->name("id")->value('HUMAN1'),
								 SOAP::Data->type('')->name("seq")->value("$inSeq2")
								          )
						        		)
							   )
						     )
						  )
				);
			      
my $response=$soap->call(SOAP::Data->name('runService')
			           ->attr({'xmlns'=>'http://www.cbs.dtu.dk/ws/WSRNAmmer_1_2_ws1'})
				    =>$params
	            		 );
#pollQueue  --jobid needs to be changed as which you got from runService
my $params=SOAP::Data
	->name("job"=>
	\SOAP::Data
	->name("jobid" =>'DF20D794-3B7A-11E1-B549-CAED4AD1FE36')
	->type(''));
    
my $response=$soap->call(SOAP::Data
		  ->name('pollQueue')
		  ->attr({'xmlns'=>'http://www.cbs.dtu.dk/ws/WSRNAmmer_1_2_ws1'})
		   =>$params
	             );	

#fetchResult   --jobid needs to be changed as which you got from runServices  
my $params=SOAP::Data->name("job"=>
	\SOAP::Data
	->name("jobid" =>'13913304-3C32-11E1-BD82-8CB1A79C20B1')
	->type(''));
     
my $response=$soap->call(SOAP::Data->name("fetchResult")
		  ->attr({'xmlns'=>'http://www.cbs.dtu.dk/ws/WSRNAmmer_1_2_ws1'})
		   =>$params
	             );	

1;

### client code ends here

#########################################################################################
#############################				    #############################
#############################          DOCUMENTATION        #############################
#############################          			    #############################
#########################################################################################

#	Introduction:

#		SOAP::Lite is a collection of Perl modules which produces a simple and lightweight 
#		interface to the SOAP both on client and server side. This version SOAP::Lite supports
#		the SOAP 1.1. specification(www.w3.org/TR/soap).

#	Installation:

#		Required/Tested version: Perl v5.10 and SOAP::Lite -v 0.60

#		The SOAP::Lite modules can be installed by:

#		1. Using the system package manager install/update the appropriate package, 
#		   for example libsoap-lite-perl for Linux systems
#		2. Using CPAN to install/update SOAP::Lite (CPAN).
#		3. Downloading the SOAP::Lite distribution and installing manually:
#		    from CPAN
#		    from soaplite(http://www.soaplite.com/)

#	Access Web sevices:

#		There are three ways to use SOAP::Lite to access a SOAP Web Service:

#		1. Generate a dynamic interface to the service (service proxy) from a WSDL at runtime
#		2. Generate a static interface to the service (service proxy) from a WSDL
#		3. Directly invoke SOAP calls against the service

#		Here, we fallow a static interface to the service (service proxy) from a WSDL. 
#		The service call requires a complex input type this needs to be built. 
#		For example to submit a job to the service,create the SOAP::Data objects to be 
#		passed to the service. You'll notice that we are using trace and debug to see 
#		the SOAP messages being sent and received. Above script is for two sequences 
#		submission at a time in the runService, if you would like to submit one or more,

#		Ths RNAmmer service code access to see one method results at once. If you would like to 
#		see runService method results then you would need to comment the rest of the methods code 
#		and for rest also same. In the runService, you need to submit required fileds like one id 
#		and corresponding sequence or more ids and their corresponding sequences as a input(STDIN) 
#		data to convert FASTA format to get the results.
#		For input data/FASTA format see example: 
#		http://www.cbs.dtu.dk/ws/RNAmmer/examples/example)

#		After getting jobid from runService then you would need to submit jobid in the pollQueue 
#		to know the status of the job. After knowing the status of the job from pollQueue then 
#		you need to submit jobid in the fetchResult to see complete final results. 
#		It means you can only see final results in the fetchResult since RNAmmer is implemented 
#		in asynchronous way

#	Compile:

#		Save above code as client.pl and compile on Linux with this command

#		 >./client.pl 
 
#	Result:
 
#		We can see SOAP Request and Response at the same time in the results.
