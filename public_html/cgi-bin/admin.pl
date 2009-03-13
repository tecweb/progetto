#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;

do "base.pl";

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub admin_func{
  print <<'EOF';
    <h2>Pagina di amministrazione</h2>
	 <ul id="admin_func">
		  <li><a href="read_pro.pl">Leggi proposte</a></li>
		  <li><a href="add_tem.pl">Aggiungi tematica</a></li>
		  <li><a href="del_tem.pl">Cancella tematica</a></li>
		  <li><a href="add_news.pl">Aggiungi news</a></li>
		  <li><a href="del_news.pl">Cancella news</a></li>
	 </div>
EOF
}

print_doc_start("Amministrazione");
if (get_user_name() eq 'admin'){
  admin_func();
}
else {
  not_admin();
}
print_doc_end();
