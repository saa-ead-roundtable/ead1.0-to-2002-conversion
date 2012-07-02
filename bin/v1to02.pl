#!/usr/bin/perl5
#
#
#2003-10-15

############################
# USER DEFINED VARIABLES
#
#
$basePath='C:\\ead2002conv\\';			# set base location	
$ENV{'path'} = $basePath.'bin';			# set environmental variable to Saxon location					
$xsl=$basePath.'xsl\\v1to02.xsl';		# location of XSL file
#
#
# END USER DEFINED VARIABLES
############################



if(@ARGV and @ARGV[0]=~m/\.xml/gi){ 		# file input determined by .xml extension
  $f=1;
  $xmlIN=@ARGV[0];
  fParseDocname($xmlIN);
  fBuildParams($docname.xml);
  print "converting $docname\t\t";
  fRun($xmlIN);
}elsif(@ARGV and @xmlIN=<@ARGV[0]/*.xml>){ 	# otherwise a directory to process
  $f=0;
}else{ 						# otherwise print useage
  fUseage();
}

foreach $xmlIN(@xmlIN){ 			#@xmlIN is set
  fParseDocname($xmlIN);
  fBuildParams($docname.xml);
  print "converting $docname\t\t";
  fRun($xmlIN);
}



###############################################################################
# subroutines


##########
# build paramter string
#
sub fBuildParams($docname){
  $isoconvdate=fISO(); # takes string 'datetime' to add GMT date

  $params="docname=\"$docname\" ";
  $params=$params."isoconvdate=\"$isoconvdate\" ";
  $params=$params."convdate=\"$isoconvdate\" ";
  return ($params);
}

##########
# build outfile/docname
#
sub fParseDocname($xmlIN){
  $xmlOUT=$xmlIN;
  $xmlOUT=~s/\.xml/\.v2002\.xml/;
  $docname="$xmlIN";
  $docname=~s/.*\\(.*).xml/\1/;
  return ($docname,$xmlOUT);
}

##########
# run the conversion
#
sub fRun($xmlIN){
  $cmd='bin\saxon -o '. $xmlOUT .' '. $xmlIN .' '.$xsl .' '. $params .'';
  $run=`$cmd`;
  #print $cmd;
  if(!$run){print "DONE\n"};
}

##########
# wite ISO date | datetime (GMT)
#
sub fISO(){
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=gmtime(time);
  $isoDT = sprintf "%4d-%02d-%02dT%02d:%02dZ",1900+$year,$mon+1,$mday,$hour,$min;
  $isoD = sprintf "%4d-%02d-%02d",1900+$year,$mon+1,$mday;
  if($_[0] eq "datetime" ){
    return ($isoDT);
  }else{
    return $isoD;
  }
}

##########
# write useage
#
sub fUseage{
  print "USEAGE:\n";
  print "\tv1to02.pl file_or_directory_to_convert \n";
  print "\t(v.2002 files are witten to the same dir as the input directory) \n";
  print "\nEXAMPLES:\n";
  print "\tv1to02.pl c:\\ead\\version1\\\t(don't forget the trailing slash!)\n";
  print "\tv1to02.pl c:\\ead\\version1\\mssa.ms.1763.xml\n\n\n\n\n";
}
