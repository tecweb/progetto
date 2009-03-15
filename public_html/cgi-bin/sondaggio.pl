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

my $tem = param('tem'); 		#dir della tematica
my $sessiont = new CGI::Session();
$sessiont->param('tems', $tem);
$sessiont->flush();

my $sol = param('sol');			#file della soluzione
my $sessions = new CGI::Session();
$sessions->param('sols', $sol);
$sessions->flush();

my $file = get_root()."tematiche/".$tem."/".$sol; #path completo

my $xp = XML::XPath->new(filename => $file);

my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

print_doc_start("Tematica","Tematica $tem","soluzione","tematiche", $sol);

print "<h3> $title </h3>\n";

print "<form action='add_sondaggio.pl'>\n";
for (my $i = 1; $i < 3; $i++)
{
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<fieldset>\n<legend> $dom </legend>\n";
	for (my $j = 1; $j < 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		print "<div><input type='radio' name='ris";
		print $j+3*($i-1);
		print "' id='ris";
		print $j+3*($i-1);
		print "' value='$risp'/><label for='ris";
		print $j+3*($i-1);
		print "'> $risp </label></div>\n";
	}
	print "</fieldset>\n";
}
print "<input type = 'submit' value = 'vota'><input type='reset' value='resetta'></form>\n";

print_doc_end();
