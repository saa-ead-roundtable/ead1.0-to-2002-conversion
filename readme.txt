Direct download link: https://github.com/saa-ead-roundtable/ead1.0-to-2002-conversion/zipball/master

DISCLAIMER: This toolset is hosted by the EAS Section (formerly EAD Roundtable) of the Society of American Archivists (henceforth "EASST"). EASST is furnishing this item "as is". EASST does not provide any warranty of the item whatsoever, whether express, implied, or statutory, including, but not limited to, any warranty of merchantability or fitness for a particular purpose or any warranty that the contents of the item will be error-free.

In no respect shall EASST incur any liability for any damages, including, but limited to, direct, indirect, special, or consequential damages arising out of, resulting from, or any way connected to the use of the item, whether or not based upon warranty, contract, tort, or otherwise; whether or not injury was sustained by persons or property or otherwise; and whether or not loss was sustained from, or arose out of, the results of, the item, or any services that may be provided by EADRT. 

====================================================
EAD version 1.0 (XML) to EAD 2002 Conversion Package
====================================================
2003-10-15
Originally maintained by Stephen Yearl

=================
1. General Notes:
=================

This conversion package is based on an XSLT conversion script (v1to02.xsl) by Daniel Pitti. Slightly modified with additions from Michael Fox & Stephen Yearl. Tested with Saxon 6.5.2, 6.5.3 & xsltproc. 

Additional documentation about the conversion package can be found in conversion.html or conversion.doc.

=====================
2. Package Structure:
=====================
\dtds\
  contains:
	EAD 2002 DTD and associated files
	ead2002.exe -- a self extracting zip archive of the above (from LOC: http://www.loc.gov/ead/ead2002a.html)

\bin\
  contains:
	instant Saxon 6.5.3 [http://saxon.sourceforge.net], an XSLT processor
	tidy [http://tidy.sourceforge.net], a utility for pretty-printing XML files
	v1to02.pl, simple perl wrapper to aid in conversion

\xsl\
  contains:
	XSLT stylesheet (v1to02.xsl) that converts v1.0 EAD to v2002 EAD.
	XSLT stylesheet (report.xsl) that creates an optional report of changes made during conversion
	XML file (iso639-2.xml) used by v1to02.xsl to create EAD 2002 langmaterial elements


============
3. Features:
============
+ converts valid EAD 1.0 to EAD 2002
+ optionally produces a report of the changes made during conversion
+ parses ISO 639-2 attribute values, writing out language code and language name, in either French or English
+ removes all deprecated and obsolete elements (replacing where appropriate)


===============
4. Limitations:
===============

+ being based on XSLT, this EAD v.1 to EAD v.2002 conversion package is designed to work only on XML instances.
+ removes all deprecated elements: The DTD allows you to continue to work with deprecated elements, though this is
  STRONGLY advised against.


==========
5. Rights:
==========

+ Free for non-profit or commercial use
+ no restrictions apply, nor rights reserved
+ no warranty explicit or implied 


=======================
6. Usage (v1to02.xsl):
=======================


CLI (DOS prompt) examples:
--------------------------

C:\ead2002conv>bin\saxon -o v2002\outputFile.xml v1\inputFile.xml xsl\v1to02.xsl
 converts inputFile.xml to outputFile, using default parameters as specified in v1to02.xsl

C:\ead2002conv>bin\saxon -o v2002\outputFile.xml \v1\inputFile.xml xsl\v1to02.xsl convdate=2003-07-16
 converts inputFile.xml to outputFile, using 2003-07-16 as the date of conversion.


optional command line parameters
--------------------------------
All parameters in the USER DEFINED VARIABLES section of v1to02.xsl script may be overridden from the command line.
Rarely will you need to adjust all but two of these optional paramaters, "docname" and "convdate"
-- "convdate" is the date of conversion (when the script is run): e.g. 2003-07-16
-- "docname" is used to  construct the name of the HTML report on the progress of the conversion.

E.g. ....docname=myfileID might create a report named myfileID.report.html

NB. A report of conversion is created by default, but this can be overridden by specifying report=n on the command line

Given that "docname" in particular will be different for each EAD v1.0 file that you convert you may optionally use
v1to02.pl-- a simple script that autodetects "docname" and "convdate" (in ISO 8601 format)


======================
7. Useage (v1to02.pl):
======================

v1to02.pl is a simple perl script to convert a single file or a directory of files to EAD 2002, automatically creating docname and convdate parameters. It is a wrapper around the Saxon XSLT processor; as such it needs knowledge of where Saxon and v1to02.xsl are located. If you alter the default locations of files in this package, modify the 
"USER MODIFIABLE VARS" section of the perl script appropriately. 

In order to use v1to02.pl, you will need to install perl. Perl can be installed from the following location: http://www.perl.com/pub/a/language/info/software.html

The following example commands assumes the following:

1) open a DOS shell. One method is to click on Start, click on Run, and key cmd.exe, and click on OK.

2) change the path to C:\ead2002conv. At the command prompt in DOS, key \ead2002conv and hit ENTER. 

Examples:
---------

bin\v1to20.pl			prints out usage information
bin\v1to02.pl v1\		
	(convert all files in this directory to EAD 2002). 
	NB. 2002 files are written to same directory, with a different name
bin\v1to02.pl v1\myEAD.xml	

(convert just this file to EAD 2002).



==========================================
8. 2002 Obsolete elements and attributes :
==========================================

OBSOLETE: Elements and attributes NOT available in EAD 2002.

elements
--------
+ <spanspec>
	v1to02.xsl eliminates this element from both <tspec> and <tgroup>
+ <tfoot>
	v1to02.xsl writes text in a <tfoot> to <row altrender="tfoot">

attributes
----------

behavior, content-role,  content-title, extent, inline, orient, pubstatus, rotate, shortentry, spanname,
tabstyle, tgroupstyle, tocentry, xlink:form
	 v1to02.xsl eliminates these attribute values

numbered
	converted to altrender="numbered" or altrender="unumbered"

	  
othersource
	converted to source="value_of_othersource"

systemid
	converted to <eadid>System ID=value_of_systemid</eadid>  

targettype (not actually in EAD v1.0)


=============================================
9. 2002 deprecated elements and attributes :
=============================================

DEPRECATED: Elements and attributes STRONLY recommended not to be used, and are not permitted by default.
	    Such elements may only be made allowable by modifying the EAD 2002 DTD.

elements
--------
+ <add>
+ <admininfo>
	v1to02.xsl, by default, UNBUNDLES the children of <add> and <admininfo>, unless:

    	* the "bundle" parameter is set to 'y', then they are bundled with <descgroup type="originalElementName">

    	* <admininfo>, <add> have a <head> or other "block" level elements (address, chronlist, list, note, table,
	 p, blockquote) they are bundled with <descgroup type="originalElementName">

	* <admininfo>, <add> consist _only_ of "block elements" they are bundles with <odd type="originalElementName">

+ <dentry>
	content written straight to the <did>
+ <drow>
	eliminated.
	
+ <organization>
	convered to <arrangement>
+ <tspec>
	eliminated

attributes
----------
langmaterial
	converted to <langmaterial><language langcode="ISO639-2b_code">language_name (in French or English)</language>

legalstatus 
	convred to, e.g. <legalstatus type="public">Public</legalstatus>
otherlegalstatus
	converted to <legalstatus type="my_other_legalstatus">my other legalstatus</legalstatus>


===============================
10. Script (v1to02.xsl) Testers:
===============================

Randall Barry
Michael Fox
Richard Higgins
Peter Johnston
Bill Landis
Paolo Mangiafico
Per-Gunnar Ottosson
Daniel Pitti
Alvin Pollock
Chris Prom
Elizabeth Shaw
MacKenzie Smith
Brian Tingle
Stephen Yearl
