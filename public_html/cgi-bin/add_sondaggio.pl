#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;

my $sessiont = new CGI::Session();
my $tem = $sessiont->param('tems');
my $sessions = new CGI::Session();
my $sol = $sessions->param('sols');
my $sessionl = new CGI::Session();
my $l = $sessions->param('luns');
my $file = get_root()."tematiche/".$tem."/".$sol; #path completo

my @par;
for(my $i=0; $i<3*$l; $i++)
{
  my $n = $i+1;
  $par[$i] = param("ris$n");
}

my $parser = XML::DOM::Parser->new;
my $doc = $parser->parsefile($file);
my $str = "";

for(my $i=0; $i<3*$l-1; $i++)
{
	my $node = $doc->getElementsByTagName('nvoti')->item($i);  #n indica se il voto da modificare è del commento 0,1,2 ecc
	my $new_voto = $node->getFirstChild()->getNodeValue();
	if(defined $par[$i])
	{
		$node->getFirstChild()->setNodeValue($new_voto+1); #setto il valore del nodo testo, che e' il primo filgio del nodo "voto"
	}
}
$doc->printToFile("$file");

my $xp = XML::XPath->new(filename => $file);

my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

$parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$file");
my $nl = $document->getElementsByTagName("domanda");
$l = $nl->getLength();

print_doc_start("Tematica","Tematica ","discussione","tematiche");

print "<h3> $title </h3>\n";

print "<table summary='";
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
print "'><caption>risultati delle votazioni</caption>\n";
for (my $i = 1; $i <= $l; $i++)
{
print "<tr class='tabella'>\n";
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<td class='tabella' colspan='2'> $dom </td></tr>\n";
	for (my $j = 1; $j < 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		my $voti=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/nvoti/text()")->value();
		print "<tr class='tabella'>\n<td class='tabella'>$risp</td>\n<td class='tabella'>$voti voti</td></tr>";
	}

}
print "</table>";

print "<span> [<a href=\"tematica.pl?ref=$tem\"> Torna alla tematica </a>] </span>";

print_doc_end();
