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
my $errs = 0;

my $pro1 = param('pro1');
my $pro2 = param('pro2');
my $pro3 = param('pro3');
my $con1 = param('con1');
my $con2 = param('con2');
my $con3 = param('con3');

my $s = CGI::Session->load();
my $nome = $s->param('name');
my $title = $s->param('ttl');
$s->flush();

my $domn = param('dom');
my $opz1 = param('opz1');
my $opz2 = param('opz2');
my $opz3 = param('opz3');
my $opz4 = param('opz4');
my $opz5 = param('opz5');

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
	 my $parser = new XML::DOM::Parser;
	 my $dom = $parser->parsefile ("$root/tematiche/$nome/$title.xml");
	 my $sl = $dom->getDocumentElement();

	 if ($pro1){
		my $pr1 = $dom->createElement("pro");
		$pr1->addText(encode_entities($pro1));
		$sl->appendChild($pr1);
	 }
	 if ($pro2){
		my $pr2 = $dom->createElement("pro");
		$pr2->addText(encode_entities($pro2));
		$sl->appendChild($pr2);
	 }
	 if ($pro3){
		my $pr3 = $dom->createElement("pro");
		$pr3->addText(encode_entities($pro3));
		$sl->appendChild($pr3);
	 }

	 if ($con1){
		my $cn1 = $dom->createElement("contro");
		$cn1->addText(encode_entities($con1));
		$sl->appendChild($cn1);
	 }
	 if ($con2){
		my $cn2 = $dom->createElement("contro");
		$cn2->addText(encode_entities($con2));
		$sl->appendChild($cn2);
	 }
	 if ($con3){
		my $cn3 = $dom->createElement("contro");
		$cn3->addText(encode_entities($con3));
		$sl->appendChild($cn3);
	 }

	 $dom->printToFile("$root/tematiche/$nome/$title.xml");
  } or err();
}

sub add_opz {
  my $opz = shift @_;
  my $dmn = shift @_;
  my $dom = shift @_;
  my $op = $dom->createElement("opzione");
  my $dsc = $dom->createElement("descrizione");
  $dsc->addText(encode_entities($opz));
  my $nv = $dom->createElement("nvoti");
  $nv->addText("0");
  $op->appendChild($dsc);
  $op->appendChild($nv);
  $dmn->appendChild($op);
}

sub add_domn {
  eval {
	 my $parser = new XML::DOM::Parser;
	 my $dom = $parser->parsefile ("$root/tematiche/$nome/$title.xml");
	 my $sl = $dom->getDocumentElement();

	 my $dmn = $dom->createElement("domanda");
	 my $txt = $dom->createElement("testo");
	 $txt->addText(encode_entities($domn));
	 $dmn->appendChild($txt);

	 if ($opz1){
		add_opz($opz1, $dmn, $dom);
	 }

	 if ($opz2){
		add_opz($opz2, $dmn, $dom);
	 }

	 if ($opz3){
		add_opz($opz3, $dmn, $dom);
	 }

	 if ($opz4){
		add_opz($opz4, $dmn, $dom);
	 }

	 if ($opz5){
		add_opz($opz5, $dmn, $dom);
	 }

	 $sl->appendChild($dmn);

	 $dom->printToFile("$root/tematiche/$nome/$title.xml");
  } or err();
}

sub form {
	 print<<'EOF';
    <form action="add_dom.pl" method="post">
	 <fieldset>
	 <legend>Aggiungi domanda</legend>
	 <div>
       <p class="lbl"><label for="dom">Domanda: </label></p>
	    <p><input type="text" size="50" id="dom" name="dom"/></p>
    </div>
	 <div>
       <p class="lbl"><label>Opzioni: </label></p>
       <ul>
	      <li><input type="text" size="50" name="opz1"/></li>
	      <li><input type="text" size="50" name="opz2"/></li>
	      <li><input type="text" size="50" name="opz3"/></li>
	      <li><input type="text" size="50" name="opz4"/></li>
	      <li><input type="text" size="50" name="opz5"/></li>
       </ul>
    </div>
    <div><input class="ok" type="submit" value="Aggiungi"/></div>
	 </fieldset>
    </form>
    <div class="btn"><a href="add_sol.pl">
	    <input class="ok" type="button" value="Aggiungi un'altra soluzione"/></a>
    </div>
EOF
    print "<div class=\"btn\"><a href=\"tematica.pl?ref=$nome\">";
	 print "   <input class=\"ok\" type=\"button\" value=\"Termina\"/></a>";
	 print "</div>";
}

print_doc_start("Aggiungi domanda");
if (get_user_name() eq 'admin'){
  add();
  if ($domn){
	 add_domn();
  }
  if ($errs == 0) {
	 form();
  }
}
else {
  not_admin();
}
print_doc_end();
