#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use File::Basename;
use File::Path;

do "base.pl";
my $root = get_root();

my @name = param('name');

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub err {
  print "<h2>Attenzione</h2>";
  print shift @_;
}

sub form {
  my @tem  = (glob("$root/tematiche/".'*'));
  if (!@tem) {
	 err("<p>Errore nell'accesso alla directory tematiche/</p>");
  }
  print<<'EOF';
    <form action="del_tem.pl" method="post">
	 <fieldset>
	 <legend>Cancella tematiche</legend>
	 <div>
EOF
  for (my $i = 0; $i < scalar(@tem); $i++){
	 my $value = basename(@tem[$i]);
		print "<p><input type=\"checkbox\" name=\"name\" value=\"$value\"/>$value</p>";
		}
  print<<'EOF';
     </div>
	 <div><input class="ok" type="submit" value="Cancella"/></div>
	 </fieldset>
    </form>
EOF
}

sub del_t{
  my @tem  = (glob("$root/tematiche/".'*'));
  if (!@tem) {
	 err("<p>Errore nell'accesso alla directory tematiche/</p>");
  } 
  foreach my $nm (@name){
	 for (my $i = 0; $i < scalar(@tem); $i++){
		if (basename(@tem[$i]) eq $nm){
		  eval {
			 my $c = rmtree ("$root/tematiche/$nm");
			 if ($c > 0) {
				print "<h2>L'operazione &egrave; stata eseguita con successo.</h2>";
			 }
		  } or err("<p>Errore nella cancellazione della tematica<p>");
		}
	 }
  }
  @name = {};
}

print_doc_start("Cancella tematiche");
if (get_user_name() eq 'admin'){
  if (@name){
	 del_t();
  }
  else{
	 form();
  }
  print "<div><a href=\"admin.pl\">Torna alla pagina di amministrazione</a></div>";
}
else {
  not_admin();
}
print_doc_end();
