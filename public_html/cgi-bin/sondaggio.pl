#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::DOM;

my $tem = param('ref') || 0; 		#directory della soluzione
my $tem_dir = get_tem_dir() . $tem;		#directory della tematica
my $parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$tem");	#file della soluzione

my $prop = $document->getElementsByTagName ("proposta");
my $proposta = $prop->item(0)->getFirstChild()->getData();

my $text = $document->getElementsByTagName ("testo");

my $desc = $document->getElementsByTagName ("descrizione");

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print	"<h4> $proposta </h4>\n";

for (my $i = 0; $i < $text->getLength(); $i++)
{
	 my $value = $text->item($i)->getFirstChild()->getData();
	 print
      "<p>$value</p>";
	for (my $j = $i*3; $j < $i*3+3; $j++)
	{
		my $value2 = $desc->item($j)->getLastChild()->getData();
		print
    	"<p>$value2</p>";
  }
}

print_proposte();

print_doc_end();

