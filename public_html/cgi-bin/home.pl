#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do "base.pl";

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

use XML::DOM;

my $root = get_root();
my $dir = "$root/eventi/index.xml";
my $parser = new XML::DOM::Parser;
my $document = $parser->parsefile ("$dir");
my $event = $document->getElementsByTagName ("evento");
my $proposta = $event->item(1)->getFirstChild()->getData();

print_doc_start('Home', 'Homepage');

print "<h3> News / Eventi</h3>\n";

for(my $i=0; $i<5; $i++)
{
	my $xp;	
	eval
	{
		$xp = XML::XPath->new(filename => "$root/eventi/index.xml");
  }
	or print "";

	print "<p>";
	print $xp->findvalue("/eventi/evento[last()-$i]/dataEvento/text()")->value();
	print ": <a href='";
	print $xp->findvalue("/eventi/evento[last()-$i]/link/text()")->value() || "";
	print "'>"; 
	print $xp->findvalue("/eventi/evento[last()-$i]/descrizione/text()")->value(); 
	print "</a></p>\n";
}

print "$proposta";

print_proposta();
print_doc_end();
