#!/usr/bin/perl

use strict;
use warnings;

do "base.pl";

use CGI qw( :standard);
use XML::XPath;
use XML::XPath::XMLParser;

my $root = get_root();
my $i=1;

sub get_news {
	my $xp;
	eval {
   	$xp = XML::XPath->new(filename => "$root/eventi/index.xml");
   } or return "";
   return $xp->findvalue("/eventi/evento[$i]/descrizione/text()")->value() || "";
}

sub get_data {
	my $xp;
	eval {
   	$xp = XML::XPath->new(filename => "../eventi/index.xml");
   } or return "";
   return $xp->findvalue("/eventi/evento[$i]/dataEvento/text()")->value() || "";
}

sub get_link {
	my $xp;
	eval {
   	$xp = XML::XPath->new(filename => "../eventi/index.xml");
   } or return "";
   return $xp->findvalue("/eventi/evento[$i]/link/text()")->value() || "";
}

print_doc_start('Home', 'Homepage');

print <<'EOF';
    <h3> News / Eventi</h3>
EOF

for($i; $i<6; $i++)
{
	my $news = get_news($i);
	my $data = get_data($i);
	my $link = get_link($i);
	print "<p> $data - <a href='$link'> $news </a></p>\n";
}

print_doc_end();
