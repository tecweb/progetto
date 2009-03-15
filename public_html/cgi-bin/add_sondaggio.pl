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

my $tem = $sessiont->param('tems');
my $SOL = $sessions->param('sols');
#my $tem = "biomasse";
#my $sol = "sol_centrale_elettrica.xml";
my $file = get_root()."tematiche/".$tem."/".$sol; #path completo

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
		print "<p>$risp</p>";
	}
}

print $par1;
print $par2;
print $par3;
print $par4;
print $par5;
print $par6;

print_doc_end();
