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

my $sol = param('sol');
my $title = param('title');
my $pro = param('pro');

my $s = CGI::Session->load();
my $nome = $s->param('name');
$s->flush();
$s = new CGI::Session();
$s->param('name', $nome);
$s->param('ttl', $title);
$s->flush();

sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub create {
  open (FILE, ">$root/tematiche/$nome/$title.xml");
  print FILE "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  print FILE "<soluzione xmlns:xs=\"http://www.w3.org/2001/XMLSchema-instance\" xs:schemaLocation=\"../../../xml/schema/tematica.xsd\">\n";
  print FILE "</soluzione>";
  close FILE;

  my $parser = new XML::DOM::Parser;
  my $dom = $parser->parsefile ("$root/tematiche/$nome/$title.xml");
  my $sl = $dom->getDocumentElement();

  my $prp = $dom->createElement("proposta");
  $prp->addText($sol);
  $sl->appendChild($prp);

  $dom->printToFile("$root/tematiche/$nome/$title.xml");
}

sub form {
	 print<<'EOF';
    <form action="/cgi-bin/add_dom.pl" method="POST">
	 <fieldset>
	 <legend>Aggiungi pro e contro</legend>
	 <p> <label for="Pro">Pro: </label></p>
	 <p><input type="text" size="50" name="pro1"/></p>
	 <p><input type="text" size="50" name="pro2"/></p>
	 <p><input type="text" size="50" name="pro3"/></p>
	 <p> <label for="Contro">Contro: </label></p>
	 <p><input type="text" size="50" name="con1"/></p>
	 <p><input type="text" size="50" name="con2"/></p>
	 <p><input type="text" size="50" name="con3"/></p>
    <p> <input class="ok" type="submit" value="Continua"/></p>
	 </fieldset>
    </form>
EOF
}

print_doc_start("Aggiungi pro e contro");
if (get_user_name() eq 'admin'){
  if (!(-e "$root/tematiche/$nome/$title.xml") && $title){
	 create();
  }
  form();
}
else {
  not_admin();
}
print_doc_end();
