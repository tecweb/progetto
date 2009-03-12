#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;

do "base.pl";

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}


sub form(){
	 print<<'EOF';
    <form action="/cgi-bin/add_sol.pl" method="POST">
	 <fieldset>
	 <legend>Aggiungi tematica</legend>
    <p>
      <label for="Nome">Nome: </label><br/>
	   <input type="text" size="50" name="name"></textarea>
	 </p>
	 <p>
	   <label for="Descrizione">Descrizione: </label><br/>
	   <textarea cols="50" rows="5" name="desc"></textarea>
	 </p>
	 <p> <input class="ok" type="submit" value="Continua" /> </p>
	 </fieldset>
    </form>
EOF
}

print_doc_start("Aggiungi tematica");
if (get_user_name() eq 'admin'){
  form();
}
else {
  not_admin();
}
print_doc_end();
