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
    <form action="/cgi-bin/add_sol.pl" method="post">
	 <fieldset>
	 <legend>Aggiungi tematica</legend>
      <div>
      <p class="lbl"><label for="name">Nome: </label></p>
	   <p><input type="text" size="50" id="name" name="name"/></p>
      </div>
	   <div>
      <p class="lbl"><label for="desc">Descrizione: </label></p>
	   <p><textarea cols="50" rows="5" id="desc" name="desc"></textarea></p>
      </div>
	   <div><input class="ok" type="submit" value="Continua" /> </div>
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
