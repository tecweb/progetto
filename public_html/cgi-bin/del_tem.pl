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
my @tem  = (glob("$root/tematiche/".'*'));

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}


sub form(){
  print<<'EOF';
    <form action="/cgi-bin/del_tem.pl" method="POST">
	 <fieldset>
	 <legend>Cancella tematiche</legend>
EOF
  for (my $i = 0; $i < scalar(@tem); $i++){
	 my $value = basename(@tem[$i]);
	 print
      "<p><input type=\"checkbox\" name=\"name\" value=\"$value\"/>$value</p>"
  }
		print<<'EOF';
	 <p> <input class="ok" type="submit" value="Cancella" /> </p>
	 </fieldset>
    </form>
EOF
}

sub del_t{
  foreach my $nm (@name){
	 for (my $i = 0; $i < scalar(@tem); $i++){
		if (basename(@tem[$i]) eq $nm){
		  rmtree ("$root/tematiche/$nm");
		  }
		}
	 }
  @name = {};
}

print_doc_start("Cancella tematiche");
if (get_user_name() eq 'admin'){
  if (@name){
	 del_t();
	 print "<h2>L'operazione &egrave; stata eseguita con successo.</h2>";
  }
  else{
	 form();
  }
}
else {
  not_admin();
}
print_doc_end();
