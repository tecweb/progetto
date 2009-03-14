#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;
use Digest::MD5 qw( md5_hex );
use Email::Valid;

do "base.pl";

my $user = param('username');
my $pass1 = param('password');
my $pass2 = param('password2');
my $email = param('email');

my $int_err = 'Errore interno. Impossibile creare account.';

sub check {
  my $exists = 0;
  eval {
    my $doc = XML::XPath->new(filename => get_root() . '/utenti.xml');
    if ($doc->find("//utenti/utente[./username/text()=\"$user\"]")) {
      $exists = 'Nome utente gi&agrave; esistente';
    }
    1;
  } or return $int_err;

  return $exists if $exists;

  unless (Email::Valid->address($email)) {
    return "L'indirizzo email non &egrave; valido";
  }
  return 'Le password non coincidono' unless $pass1 eq $pass2;

  return 0;
}

my $err = check();

my $session = new CGI::Session();
$session->expire('+2h');
my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);

sub manage_error {
  my $msg = shift @_;
  $session->param('create-failed', $msg);
  print header(-cookie=>$cookie, -Location => "login.pl");
}

if ($err) {
  manage_error($err);
} else {
  ## aggiungi al db
  my $parser = new XML::DOM::Parser;
  eval {
    my $doc = $parser->parsefile(get_root() . "/utenti.xml");
    my $utenti = $doc->getElementsByTagName('utenti')->item(0);
    my $new_user = $doc->createElement('utente');

    my $u = $doc->createElement('username');
    $u->addText($user);
    my $pass = $doc->createElement('md5pass');
    $pass->addText(md5_hex($pass1));
    my $em = $doc->createElement('email');
    $em->addText($email);

    $new_user->appendChild($u);
    $new_user->appendChild($pass);
    $new_user->appendChild($em);

    $utenti->appendChild($new_user);

    ## flush
    $doc->printToFile(get_root() . '/utenti.xml');
    $session->param('~username', $user); # login
    print header(-cookie=>$cookie, -Location => "home.pl");
    1;
  } or manage_error($int_err);
}

$session->flush();
