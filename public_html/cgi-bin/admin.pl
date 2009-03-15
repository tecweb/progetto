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

my $i = load_tem();
$i += 6;

sub admin_func{
  print <<'EOF';
    <h2>Pagina di amministrazione</h2>
	 <ul id="admin_func">
EOF
  print "<li><a href=\"read_pro.pl\" tabindex=\"$i\">Leggi proposte</a></li>";
  $i += 1;
  print "<li><a href=\"add_tem.pl\" tabindex=\"$i\">Aggiungi tematica</a></li>";
  $i += 1;
  print "<li><a href=\"del_tem.pl\" tabindex=\"$i\">Cancella tematica</a></li>";
  $i += 1;
  print "<li><a href=\"add_news.pl\" tabindex=\"$i\">Aggiungi news</a></li>";
  $i += 1;
  print "<li><a href=\"del_news.pl\" tabindex=\"$i\">Cancella news</a></li>";
  print "</ul>";

}

print_doc_start("Amministrazione");
if (get_user_name() eq 'admin'){
  admin_func();
}
else {
  not_admin();
}
print_doc_end();
