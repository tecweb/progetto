#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

my $file = param('ref'); 		#file della soluzione
my $xp = XML::XPath->new(filename => $file);
#my $dom = $xp->findvalue('/soluzione/domanda')->value();
my $title = $xp->findvalue('/soluzione/proposta/text()')->value();

my $pros = $xp->find('soluzione/domanda/testo/text()');

print_doc_start("Tematica","Tematica ","discussione","tematiche");

print "<h3> $title </h3>\n";

print "<form action=''>\n";
for (my $i = 1; $i < 3; $i++)
{
	my $dom = $xp->findvalue("/soluzione/domanda[$i]/testo/text()")->value();
	print "<fieldset>\n<legend> $dom </legend>\n";
	for (my $j = 1; $j < 4; $j++)
	{
		my $risp=  $xp->findvalue("/soluzione/domanda[$i]/opzione[$j]/descrizione/text()")->value();
		my $dom_risp = $dom.$risp;
		print "<div><input type='checkbox' name='$dom_risp' id='$dom_risp' value='$dom_risp'/><label for='$dom_risp'> $risp </label></div>\n";
	}
	print "</fieldset>\n";
}
print "</form>\n";

print_doc_end();
