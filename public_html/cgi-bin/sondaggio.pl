#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use CGI::Session;
use XML::DOM;
use XML::XPath;
use XML::XPath::XMLParser;
use URI::Escape;

my $tem = uri_unescape(param('tem')); 		#dir della tematica
my $sessiont = new CGI::Session();
$sessiont->param('tems', $tem);
$sessiont->flush();

my $sol = uri_unescape(param('sol'));			#file della soluzione
my $sessions = new CGI::Session();
$sessions->param('sols', $sol);
$sessions->flush();

my $file = get_root()."tematiche/".$tem."/".$sol; #path completo

my $xp = XML::XPath->new(filename => $file);

my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

my $parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$file");
my $nl = $document->getElementsByTagName("domanda");

my $l = $nl->getLength();
my $sessionl = new CGI::Session();
$sessionl->param('luns', $l);
$sessionl->flush();

print_doc_start("Tematica","Tematica $tem","soluzione","tematiche", $sol);

print "<h3> $title </h3>\n";

print "<form action='add_sondaggio.pl'>\n";
for (my $i = 1; $i <= $l; $i++)
{
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<fieldset>\n<legend> $dom </legend>\n";
	for (my $j = 1; $j <= 3; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		print "<div><input type='radio' name='ris";
		print $j+3*($i-1);
		print "' id='ris";
		print $j+3*($i-1);
		print "' value='$risp' /><label for='ris";
		print $j+3*($i-1);
		print "'> $risp </label></div>\n";
	}
	print "</fieldset>\n";
}
print "<fieldset><input type = 'submit' value = 'vota' /><input type='reset' value='resetta' /></fieldset></form>\n";

print "<span> [<a href=\"tematica.pl?ref=$tem\"> Torna alla tematica </a>] </span>";

print_doc_end();
