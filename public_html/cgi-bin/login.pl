#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::XPath;

do "base.pl";

my $user = param('username');
my $pass = param('password');
my $root = get_root();

my $xp = XML::XPath->new(filename => "$root/utenti.xml");
my $md5;
if ($user && $pass) {
    $md5 = $xp->findvalue("//utenti/utente[./username/text()=\"$user\"]/md5pass/text()")->value();

    ## TODO: calcola md5 di pass
    unless ($pass eq $md5) {
        $user = "";
    }
}

if ($user) {
    ## login ok: vai alla homepage
    my $session = new CGI::Session();
    $session->expire('+2h');
    $session->param('~username', $user);
    $session->flush();
    my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);
    print header(-cookie=>$cookie, -Location => "/cgi-bin/home.pl");
} else {
    ## non ancora loggato
    print_doc_start("Login");
    print STDERR script_name();
    if (basename(referer()) eq basename(script_name())) {
        ## gia' provato
        print '<p class="errore"> Username o password sbagliati </p>';
    }
    print <<'EOF';    
    <form action="/cgi-bin/login.pl" method="POST">
      <fieldset>
      <legend> Esegui login </legend>
      <p>
        <label for="username"> Username: </label>
        <input type="text" size="20" name="username" />
      </p>
      <p>
	<label for="password"> Password: </label>
        <input type="password" size="20" maxlength="256" name="password" />
      </p>
      <p> <input type="submit" value="Login" /> </p>
      <!-- TODO: aggiungere creazione account -->
      </fieldset>
    </form>
EOF
    print_doc_end();
}
