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
my $event = $document->getElementsByTagName ("descrizione");
my $date = $document->getElementsByTagName ("dataEvento");
my $link = $document->getElementsByTagName ("link");
my @proposta;
my %x;

sub print_news
{
	print "<h3> News / Eventi</h3>\n";
	for(my $i=0; $i<$event->getLength(); $i++)
	{
		@proposta[$i] = $date->item($i)->getFirstChild()->getData().": ".$event->item($i)->getFirstChild()->getData();
		$x{@proposta[$i]} =	 $link->item($i)->getFirstChild()->getData()	;
	}

	@proposta = sort {$b cmp $a} @proposta;

	for(my $i=0; $i<5; $i++)
	{
		print "<p><a href=";
		print "'$x{@proposta[$i]}'";
		print " tabindex='";
		print $i+1;
		print "'> @proposta[$i] </a></p>\n";
	}
}

print_doc_start('Home', 'Homepage');
print_news();
print_doc_end();
