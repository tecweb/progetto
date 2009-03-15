#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

my $tem = param('tem'); 		#file della soluzione
my $sol = param('sol'); 		#file della soluzione
my $file = get_root()."tematiche/".$tem."/".$sol.".xml";
my $xp = XML::XPath->new(filename => $file);
#my $dom = $xp->findvalue('/soluzione/domanda')->value();
my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

my $pros = $xp->find('soluzione/domanda/testo/text()');

print_doc_start("Tematica","Tematica ","discussione","tematiche");

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
