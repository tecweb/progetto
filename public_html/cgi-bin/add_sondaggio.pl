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

my $parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$file");
my $nl = $document->getElementsByTagName("domanda");
my $l = $nl->getLength();

print_doc_start("Tematica","Tematica ","discussione","tematiche");

print "<h3> $title </h3>\n";

print "<table><caption summary='";
for (my $i = 1; $i <= $l; $i++)
{
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
print "$dom";
	for (my $j = 1; $j <= 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		my $voti=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/nvoti/text()")->value();
		print "$risp, $voti voti.";
	}
}
print "'>risultati delle votazioni</caption>\n";
for (my $i = 1; $i <= $l; $i++)
{
print "<tr class='tabella'>\n";
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<td class='tabella' colspan='2'> $dom </td>\n";
	for (my $j = 1; $j < 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		my $voti=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/nvoti/text()")->value();
		print "<tr class='tabella'>\n<td class='tabella'>$risp</td>\n<td class='tabella'>$voti voti</td></tr>";
	}
print "</tr>";
}
print "</table>";

print "<span> [<a href=\"/cgi-bin/tematica.pl?ref=$tem\"> Torna alla tematica </a>] </span>";

print_doc_end();
