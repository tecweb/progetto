#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );

do "base.pl";

my $from = param('from') || 0;
$from = 0 if $from < 0;
my $to = $from + 9;

print_doc_start("Tematiche");

my @tem = map { basename($_) } get_ordered_tem();
my $n = $#tem;
$from = $n if $from > $n;
$to = $n if $to > $n;
@tem = @tem[$from .. $to];

print "<h1 id=\"tem_list_title\"> Da $from a $to </h1>";

print '<ol id="tem_list">';
print "<li> <a href=\"/cgi-bin/tematica.pl?ref=$_\"> $_ </a> </li>" foreach (@tem);
print '</ol>';

if ($from > 0) {
  print '<a id="a_prec" href="/cgi-bin/mostra_tematiche.pl?from=', $from-10, 
    '"> &lt; Precedenti </a>';
}

if ($to < $n) {
  print '<a id="a_succ" href="/cgi-bin/mostra_tematiche.pl?from=', $from+10, 
    '"> Seguenti &gt; </a>';
}


print_doc_end();
