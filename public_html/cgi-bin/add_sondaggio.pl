#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

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

my $sessiont = new CGI::Session();
my $tem = $sessiont->param('tems');
my $sessions = new CGI::Session();
my $sol = $sessions->param('sols');
my $file = get_root()."tematiche/".$tem."/".$sol; #path completo

my $parser = XML::DOM::Parser->new;
my $doc = $parser->parsefile($file);

my $n=0;
my $new_voto=1;
my $node = $doc->getElementsByTagName('nvoti')->item($n);  #n indica se il voto da modificare è del commento 0,1,2 ecc
$node->getFirstChild()->setNodeValue($new_voto); # setto il valore del nodo testo, che e' il primo filgio del nodo "voto"
#$doc->printToFile("$file");

my $xp = XML::XPath->new(filename => $file);

my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

print_doc_start("Tematica","Tematica ","discussione","tematiche");

print "<h3> $title </h3>\n";

for (my $i = 1; $i < 3; $i++)
{
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<p> $dom </p>";
	for (my $j = 1; $j < 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		my $voti=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/nvoti/text()")->value();
		print "<p>$risp $voti voti</p>";
	}
}

print $node->getFirstChild()->getNodeValue();

print_doc_end();
