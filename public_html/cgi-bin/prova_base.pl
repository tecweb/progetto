#!/usr/bin/perl

use strict;
use warnings;
do "base.pl";

print_head("Prova");
print "<body>";
print_header();
print_nav();
my $name = user_name() || "";
print "<p> $name </p>";
print "</body>";
