#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;

do "base.pl";
my $root = get_root();

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub err {
  print "<h2>Attenzione!</h2>";
  print "<p>Si &egrave; verificato un errore nell'apertura del file.</p>";
}

sub pro(){
  eval {
	 my $parser = new XML::DOM::Parser;
	 my $dom = $parser->parsefile ("$root/suggerimenti.xml");
	 my $sgg = $dom->getElementsByTagName("suggerimento");

	 print "<h2>Proposte e suggerimenti</h2>";
	 print "<div>";
	 for (my $s = 0; $s < $sgg->getLength(); $s++){
		my $u = $dom->getElementsByTagName("utente")->item($s)->getFirstChild()->getData();
		my $t = $dom->getElementsByTagName("testo")->item($s)->getFirstChild()->getData();
		print "<p class=\"pro_u\">$u</p>";
		print "<p class=\"pro_t\">$t</p>";
  }
  print "</div>";
  } or err();
}



print_doc_start("Leggi proposte");
if (get_user_name() eq 'admin'){
	 pro();
	 print "<div><a href=\"admin.pl\">Torna alla pagina di amministrazione</a></div>";
  }
else {
  not_admin();
}
print_doc_end();
