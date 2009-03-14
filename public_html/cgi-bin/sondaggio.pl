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
my $prop_text = $prop->item(0)->getFirstChild()->getData();

my $quiz = $document->getElementsByTagName ("domanda");

my $dom = $document->getElementsByTagName ("testo");



my $i = 0;

sub print_dom
{
	my $dom_text = $dom->item($i)->getFirstChild()->getData();
	print "<p>$dom_text</p>";
}

sub print_risp
{
	
}

#my $desc = $document->getElementsByTagName ("descrizione");

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print	"<h3> $prop_text </h3>\n";

for($i = 0; $i < $dom->getLength(); $i++)
{
	print_dom($i);
	print_risp();
}

#for (my $i = 0; $i < $text->getLength(); $i++)
#{
#	my $value = $text->item($i)->getFirstChild()->getData();
#	print <<'EOF';
#<form action="" method="">
#<fieldset>
#EOF
#	print "<legend> $value </legend>\n";
#	for (my $j = $i*3; $j < $i*3+3; $j++)
#	{
#		my $value2 = $desc->item($j)->getLastChild()->getData();
#		print "<div><input type='checkbox' name='$value2' id='$value2' value='$value2'/><label for='$value2'> $value2 </label></div>\n";
#  }
#	print "</fieldset></form>\n";
#}

print_doc_end();
