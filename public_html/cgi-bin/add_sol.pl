#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use File::Path;

do "base.pl";

my $root = get_root();
my $nome = param('name');

if (!$nome){
  my $ss = CGI::Session->load();
  $nome = $ss->param('name');
  $ss->flush();
}
my $s = new CGI::Session();
$s->param('name', $nome);
$s->flush();

my $desc = param('desc');

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub add(){
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
  $dsc->addText($desc);
  $tem->appendChild($dsc);

  $dom->printToFile("$root/tematiche/$nome/index.xml");
}

sub form(){
	 print<<'EOF';
    <form action="/cgi-bin/add_pro_contro.pl" method="POST">
	 <fieldset>
	 <legend>Aggiungi soluzione</legend>
	 <p>
	   <div><label for="Titolo">Titolo: </label></div>
	   <div><input type="text" size="50" name="title"></input></div>
	 </p>
	 <p>
	   <div><label for="Soluzione">Soluzione: </label></div>
	   <div><textarea cols="50" rows="5" name="sol"></textarea></div>
	 </p>
    <p> <input class="ok" type="submit" value="Continua"/></p>
	 </fieldset>
    </form>
EOF
}

print_doc_start("Aggiungi soluzione");
if (get_user_name() eq 'admin'){
  if (!(-e "$root/tematiche/$nome/index.xml")){
	 add();
  }
  form();
}
else {
  not_admin();
}
print_doc_end();
