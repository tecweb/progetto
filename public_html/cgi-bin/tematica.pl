#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;
use URI::Escape;

my $tem = param('ref'); 		#tematica selezionata
my $tem_dir = get_tem_dir().$tem;		#directory della tematica specifica
my $desc = tem_descr();		#descrizione della tematica

sub tem_descr {
	my $xp;
	eval {
   	$xp = XML::XPath->new(filename => "$tem_dir/index.xml");
   } or undef $xp;
   return $xp->findvalue('/tematica/descrizione/text()')->value() || "";
}

sub print_proposta {
	my $xp;	
	eval {
     $xp = XML::XPath->new(filename => $_[0]);
   } or undef $xp;
	my $prop = $xp->findvalue('/soluzione/proposta/text()')->value() || "";
	print "<h4 class=\"proposta\"> $prop </h4>\n";
	#lista dei pro	
	my $pros = $xp->find('soluzione/pro/text()');
	#lista dei contro
	my $cons = $xp->find('soluzione/contro/text()');
	print <<'EOF';	
<ul> Pro </ul>				
EOF
	foreach my $pro ($pros->get_nodelist) {
		print "<li>",XML::XPath::XMLParser::as_string($pro),"</li>\n";
	}
	print "<ul> Contro </ul>\n";
	foreach my $con ($cons->get_nodelist) {
		print "<li>",XML::XPath::XMLParser::as_string($con),"</li>\n";
	}
}

sub files_in_dir {
  my $d = shift @_;
  my @res = ();
  opendir DIR, $d;
  my $f;
  while ($f = readdir DIR) {
    if ($f ne '.' && $f ne '..') {
      push @res, "$d/$f";
    }
  }
  closedir DIR;
  return @res;
}

sub print_proposte {
	my @files = files_in_dir($tem_dir);#glob "$tem_dir/*";
	foreach my $file (@files) {
		my $filename = fileparse($file);		
		#controllo quale file sto per andare ad aprire		
		if($filename ne "index.xml")
		{	print_proposta($file); 
                        $tem = uri_escape($tem);
                        $filename = uri_escape($filename);
			print <<"EOF";
			<span> [<a href="sondaggio.pl?tem=$tem&amp;sol=$filename"> Vai all'approfondimento </a>] </span>
EOF
		}
	}
}

print_doc_start("Tematica","Tematica $tem","discussione","tematiche",$tem);

print "<h2 id=\"tem_title\"> $tem </h2>\n";
print "<p> [<a href='commenti.pl?ref=$tem'> Vai ai commenti </a>] </p>";
print	"<p> $desc </p>\n";

print_proposte();

print_doc_end();
