#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI::Session;
do "base.pl";

print_doc_start('Modifica profilo', 'Modifica il profilo', 'profilo', 'modifica');

if (defined get_user_name()) {
  my $session = get_session();
  my $err = $session->param('~errore-modifica');
  if (defined $err) {
    $session->clear('~errore-modifica');
    $session->flush();
    print '<p class="errore">', $err, '<p>';
  }
  if ($session->param('~modifica-ok')) {
    $session->clear('~modifica-ok');
    $session->flush();
    print '<p class="successo"> Modifiche effettuate con successo. </p>';
  }
  print <<'EOF';
    <form action="modifica_utente.pl" method="post">
      <fieldset>
        <legend> Modifica i tuoi dati </legend>
        <p> Lascia i campi vuoti per non modificare il loro valore attuale </p>
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
        <p> <input class="ok" type="submit" value="Modifica" /> </p>
     </fieldset>
   </form>
EOF
} else {
  print '<p class="errore"> Devi effettuare il <a href="login.pl">login</a> per  modificare il tuo profilo </p>';
}

print_doc_end();
