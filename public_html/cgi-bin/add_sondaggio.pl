#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;

do "base.pl";

my $root = get_root();

my $ydate = param('ydate');
my $mdate = param('mdate');
my $ddate = param('ddate');
my $title = param('title');
my $desc = param('desc');
my $link = param('link');


