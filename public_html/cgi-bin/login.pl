#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::XPath;

my $doc_root = '../';

my $session = new CGI::Session();
my $id = $session->id();
$session->expire('+2h'); # two hours of inacticity

my $user = param('username');
my $pass = param('password');

my $xp = XML::XPath->new(filename => "$doc_root/utenti.xml");
my $md5;
if ($user && $pass) {
    $md5 = $xp->findvalue("//utenti/utente[./username/text()=\"$user\"]/md5pass/text()")->value();

    ## TODO: calcola md5 di pass
    if ($pass eq $md5) {
        $session->param('~username', $user);
        $session->flush();
    }
}

# torna alla pagina precedente
my $ref = referer();
my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);
print header(-cookie=>$cookie, -Location => $ref);
