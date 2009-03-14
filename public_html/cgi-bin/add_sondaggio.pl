#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;

my $par1 = param("ris1");
my $par2 = param("ris2");
my $par3 = param("ris3");
my $par4 = param("ris4");
my $par5 = param("ris5");
my $par6 = param("ris6");

print_doc_start("Tematica","Tematica ","discussione","tematiche");

print $par1;
print $par2;
print $par3;
print $par4;
print $par5;
print $par6;

print_doc_end();
