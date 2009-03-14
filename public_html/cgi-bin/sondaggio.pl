#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

my $tem = param('ref') || 0; 		#file della soluzione
#my $tem_dir = get_tem_dir() . $tem;		#directory della tematica
my $xp = XML::XPath->new(filename => $tem);

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print "<h3>"; 
print $xp->findvalue('/soluzione/proposta/text()')->value();
print "</h3>";

print_doc_end();
