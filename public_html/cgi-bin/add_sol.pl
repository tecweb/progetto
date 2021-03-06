#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use File::Path;
use HTML::Entities;

do "base.pl";

my $root = get_root();
my $nome = param('name');
my $errs = 0;

my $s = CGI::Session->load();
if (!$nome) {
  $nome = $s->param('name');
}
$s->param('name', $nome);
$s->flush();

my $desc = param('desc');

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub err {
  print "<h2>Attenzione</h2>";
  print "<p>Si &egrave; verificato un errore nell'accesso al file.</p>";
  $errs = 1;
}

sub add {
  eval {
         mkpath ("$root/tematiche/$nome");
	 open (FILE, ">$root/tematiche/$nome/index.xml");
	 print FILE "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
	 print FILE "<tematica xmlns:xs=\"http://www.w3.org/2001/XMLSchema-instance\" xs:schemaLocation=\"../../../xml/schema/tematica.xsd\">\n";
	 print FILE "</tematica>";
	 close FILE;

	 my $parser = new XML::DOM::Parser;
	 my $dom = $parser->parsefile ("$root/tematiche/$nome/index.xml");
	 my $tem = $dom->getDocumentElement();

	 my $dsc = $dom->createElement("descrizione");
	 $dsc->addText(encode_entities($desc));
	 $tem->appendChild($dsc);

	 $dom->printToFile("$root/tematiche/$nome/index.xml");
  } or err();
}

sub form(){
	 print<<'EOF';
    <form action="add_pro_contro.pl" method="post">
	 <fieldset>
	 <legend>Aggiungi soluzione</legend>
	 <div>
	   <p class="lbl"><label for="title">Titolo: </label></p>
	   <p><input type="text" size="50" id="title" name="title"/></p>
	 </div>
	 <div>
	   <p class="lbl"><label for="sol">Soluzione: </label></p>
	   <p><textarea cols="50" rows="5" id="sol" name="sol"></textarea></p>
	 </div>
    <div><input class="ok" type="submit" value="Continua"/></div>
	 </fieldset>
    </form>
EOF
}

print_doc_start("Aggiungi soluzione");
if (get_user_name() eq 'admin'){
  if (!(-e "$root/tematiche/$nome/index.xml") && $nome){
	 add();
  }
  if ($errs == 0){
	 form();
  }
}
else {
  not_admin();
}
print_doc_end();
