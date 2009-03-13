#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::DOM;
use XML::XPath;
use XML::XPath::XMLParser;

my $tem = param('ref') || 0; 		#directory della soluzione
my $tem_dir = get_tem_dir() . $tem;		#directory della tematica
my $parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$tem");	#file della soluzione

my $prop = $document->getElementsByTagName ("proposta");
my $proposta = $prop->item(0)->getFirstChild()->getData();

my $text = $document->getElementsByTagName ("testo");

my $desc = $document->getElementsByTagName ("descrizione");

#sub print_proposta {
#	my $xp;	
#	eval {
#     $xp = XML::XPath->new(filename => $_[0]);
#   } or print "";
#	my $prop = $xp->findvalue('/soluzione/domanda/testo/text()')->value() || "";
#	print "<h4 class=\"proposta\"> $prop </h4>\n";
#	#lista dei pro	
#	my $pros = $xp->find('soluzione/domanda/opzione/descrizione/text()');
#	#lista dei contro
#	my $cons = $xp->find('soluzione/contro/text()');
#	print <<'EOF';	
#<dl>
#<dt> Pro </dt>				
#EOF
#	foreach my $pro ($pros->get_nodelist) {
#		print "<dd>",XML::XPath::XMLParser::as_string($pro),"</dd>\n";
#	}
#	print "<dt> Contro </dt>\n";
#	foreach my $con ($cons->get_nodelist) {
#		print "<dd>",XML::XPath::XMLParser::as_string($con),"</dd>\n";
#	}
#	print "</dl>\n";
#}

#sub print_proposte {
#	my @files = glob "$tem_dir/";
#	foreach my $file (@files) {
#		my $filename = fileparse($file);		
#		#controllo quale file sto per andare ad aprire		
#		if($filename ne "index.xml")
#		{	print_proposta($file); 
#			print "<span> [<a href=\"/cgi-bin/sondaggio.pl?ref=$file\"> Vai all'approfondimento </a>] </span>";
#			print "<span> [<a href=\"/cgi-bin/commenti.pl?ref=$tem_dir\"> Vai ai commenti </a>] </span>";
#		}
#	}
#}

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print	"<p> $proposta </p>\n";

for (my $i = 0; $i < $text->getLength(); $i++){
	 my $value = $text->item($i)->getFirstChild()->getData();
	 print
      "<p>$value</p>"
  }

for (my $i = 0; $i < $desc->getLength(); $i++){
	 my $value = $desc->item($i)->getFirstChild()->getData();
	 print
      "<p>$value</p>"
  }

print_proposte();

print_doc_end();

