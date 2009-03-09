#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;

do "base.pl";

my $user = param('username');
my $pass1 = param('password');
my $pass2 = param('password2');
my $email = param('email');

sub check {
    my $doc = XML::XPath->new(filename => get_root() . '/utenti.xml');
    if ($doc->find("//utenti/utente[./username/text()=\"$user\"]")) {
        return 'Nome utente gi&agrave; esistente'; 
    }
    
    return 'Le password non coincidono' unless $pass1 eq $pass2;
    return 0;
}

my $err = check();

my $session = new CGI::Session();
$session->expire('+2h');
my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);

if ($err) {
    $session->param('create-failed', $err);
    print header(-cookie=>$cookie, -Location => "/cgi-bin/login.pl");
    print STDERR $err;
    ## TODO: check email
} else {
    $session->param('~username', $user); # login
    ## add to db
    my $parser = new XML::DOM::Parser;
    my $doc = $parser->parsefile(get_root() . "/utenti.xml");
    my $utenti = $doc->getElementsByTagName('utenti')->item(0);
    my $new_user = $doc->createElement('utente');

    my $u = $doc->createElement('username');
    $u->addText($user);
    my $pass = $doc->createElement('md5pass');
    $pass->addText($pass1);
    my $em = $doc->createElement('email');
    $em->addText($email);

    $new_user->appendChild($u);
    $new_user->appendChild($pass);
    $new_user->appendChild($em);

    $utenti->appendChild($new_user);

    ## flush
    $doc->printToFile(get_root() . '/utenti.xml');

    print header(-cookie=>$cookie, -Location => "/cgi-bin/home.pl");
}

$session->flush();
