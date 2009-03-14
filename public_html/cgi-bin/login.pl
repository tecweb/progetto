#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::XPath;
use Digest::MD5 qw( md5_hex );

do "base.pl";

my $user = param('username');
my $pass = param('password');
my $root = get_root();

my $xp;
eval {
  $xp = XML::XPath->new(filename => "$root/utenti.xml");
} or undef $xp;

my $md5;
my $bad_login = 0;
if (defined $user && defined $pass) {
  eval {
    $md5 = $xp->findvalue("//utenti/utente[./username/text()=\"$user\"]/md5pass/text()")->value();
    1;
  } or undef $md5;
  if (defined $md5) {
    unless (md5_hex($pass) eq $md5) {
      $bad_login = "Username o password sbagliati.";
    }
  } else {
    $bad_login = "Errore interno. Impossibile effettuare il login.";
  }
}

if (defined $user && !$bad_login) {
  ## login ok: vai alla homepage
  my $session = new CGI::Session();
  $session->expire('+2h');
  $session->param('~username', $user);
  $session->flush();
  my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);
  print header(-cookie=>$cookie, -Location => "home.pl");
} else {
  ## non ancora loggato
  print_doc_start('Login', 'Pagina per effettuare il login o la registrazione',
                  'login', 'registrazione');
  if ($bad_login) {
    print "<p class=\"errore\"> $bad_login </p>";
  }
  print <<'EOF';    
    <form action="login.pl" method="post">
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
      <p> <input class="ok" type="submit" value="Login" /> </p>
      </fieldset>
    </form>
EOF
  my $err = get_session()->param('create-failed');
  if ($err) {
    print "<p class=\"errore\"> $err </p>";
    get_session()->clear('create-failed');
  }
  print <<'EOF';
    <form action="new-account.pl" method="post">
      <fieldset>
        <legend> Crea un nuovo account </legend>
        <p>
          <label for="username"> Username: </label>
          <input type="text" size="20" id="username" name="username" />
        </p>
        <p>
	  <label for="password"> Password: </label>
          <input type="password" size="20" maxlength="256" id="password" name="password" />
        </p>
        <p>
	  <label for="password2"> Password (conferma): </label>
          <input type="password" size="20" maxlength="256" id="password2" name="password2" />
        </p>
        <p>
	  <label for="email"> E-mail: </label>
          <input type="text" size="20" maxlength="256" id="email" name="email" />
        </p>
        <p> <input class="ok" type="submit" value="Crea" /> </p>
     </fieldset>
   </form>
EOF
    print_doc_end();
}
