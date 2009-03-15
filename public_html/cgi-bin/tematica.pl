#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

my $tem = param('ref') || 0; 		#tematica selezionata
my $tem_dir = get_tem_dir() . $tem;		#directory della tematica specifica
my $desc = tem_descr();		#descrizione della tematica

sub tem_descr {
	my $xp;
	eval {
   	$xp = XML::XPath->new(filename => $tem_dir . '/index.xml');
   } or return "";
   return $xp->findvalue('/tematica/descrizione/text()')->value() || "";
}

sub print_proposta {
	my $xp;	
	eval {
     $xp = XML::XPath->new(filename => $_[0]);
   } or print "";
	my $prop = $xp->findvalue('/soluzione/proposta/text()')->value() || "";
	print "<h4 class=\"proposta\"> $prop </h4>\n";
	#lista dei pro	
	my $pros = $xp->find('soluzione/pro/text()');
	#lista dei contro
	my $cons = $xp->find('soluzione/contro/text()');
	print <<'EOF';	
<dl>
<dt> Pro </dt>				
EOF
	foreach my $pro ($pros->get_nodelist) {
		print "<dd>",XML::XPath::XMLParser::as_string($pro),"</dd>\n";
	}
	print "<dt> Contro </dt>\n";
	foreach my $con ($cons->get_nodelist) {
		print "<dd>",XML::XPath::XMLParser::as_string($con),"</dd>\n";
	}
	print "</dl>\n";
}

sub print_proposte {
	my @files = glob "$tem_dir/*";
	foreach my $file (@files) {
		my $filename = fileparse($file);		
		#controllo quale file sto per andare ad aprire		
		if($filename ne "index.xml")
		{	print_proposta($file); 
			print "<span> [<a href=\"/cgi-bin/sondaggio.pl?tem=$tem&sol=sol_centrale_elettrica\"> Vai all'approfondimento </a>] </span>";
			print "<span> [<a href=\"/cgi-bin/commenti.pl?ref=$tem_dir\"> Vai ai commenti </a>] </span>";
		}
	}
}

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print "<h2 id=\"tematica\"> $tem </h2>\n";
print	"<p> $desc </p>\n";

print_proposte();

print_doc_end();

