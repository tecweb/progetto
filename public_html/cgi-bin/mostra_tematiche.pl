#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use XML::XPath;
use URI::Escape;

do "base.pl";

my $from = param('from') || 1;
$from = 1 if $from < 1;
my $to = $from + 9;

sub tem_descr {
  my $xp;
  eval {
    $xp = XML::XPath->new(filename => get_tem_dir() . $_ . '/index.xml');
  } or return "";
  eval {
    return $xp->findvalue('/tematica/descrizione/text()')->value();
  } or return "";
}

print_doc_start("Tematiche", "visualizzazione di tutte le tematiche, ordinate per data", "tematiche");

my @tem = map { basename($_) } get_ordered_tem();
my $n = $#tem + 1;
$from = $n if $from > $n;
$to = $n if $to > $n;
@tem = @tem[$from-1 .. $to-1];

print "<h1 id=\"tem_list_title\"> Da $from a $to </h1>";

print '<ol id="tem_list">';

my $i = $from;
foreach (@tem) {
  my $d = tem_descr($_);
  my $link = uri_escape($_);
  ## numerazione a mano per non ripartire sempre da 1
  print "<li> $i. <a href=\"tematica.pl?ref=$link\"> $_ </a> <p> $d </p> </li>";
  $i++;
}

print '</ol>';

if ($from > 1) {
  print '<a id="a_prec" href="mostra_tematiche.pl?from=', $from-10, 
    '" accesskey="p"> &lt; Precedenti </a>';
}

if ($to < $n) {
  print '<a id="a_succ" href="mostra_tematiche.pl?from=', $from+10, 
    '" accesskey="s"> Seguenti &gt; </a>';
}

print_doc_end();
