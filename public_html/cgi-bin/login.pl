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
my $bad_login = 0;
if (defined $user && defined $pass) {
    $md5 = $xp->findvalue("//utenti/utente[./username/text()=\"$user\"]/md5pass/text()")->value();

    ## TODO: calcola md5 di pass
    unless ($pass eq $md5) {
        $bad_login = 1;
    }
}

if (defined $user && !$bad_login) {
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
    if ($bad_login) {
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
      </fieldset>
    </form>
EOF
    my $err = get_session()->param('create-failed');
    if ($err) {
        print "<p class=\"errore\"> $err </p>";
        get_session()->clear('create-failed');
    }
    print << 'EOF';
    <form action="/cgi-bin/new-account.pl" method="POST">
      <fieldset>
        <legend> Crea un nuovo account </legend>
        <p>
          <label for="username"> Username: </label>
          <input type="text" size="20" name="username" />
        </p>
        <p>
	  <label for="password"> Password: </label>
          <input type="password" size="20" maxlength="256" name="password" />
        </p>
        <p>
	  <label for="password2"> Password (conferma): </label>
          <input type="password" size="20" maxlength="256" name="password2" />
        </p>
        <p>
	  <label for="email"> E-mail: </label>
          <input type="text" size="20" maxlength="256" name="email" />
        </p>
        <p> <input type="submit" value="Crea" /> </p>
     </fieldset>
   </form>
EOF
    print_doc_end();
}
