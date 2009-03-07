#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;

my $session = new CGI::Session();
my $id = $session->id();
$session->clear('~username');
$session->flush();

## torna indietro
my $ref = referer();
my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);
print header(-cookie=>$cookie, -Location => $ref);
