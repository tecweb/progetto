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
$s = new CGI::Session();
$s->param('name', $nome);
$s->param('ttl', $title);
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
  die();
}

sub add {
  eval {
	 my $parser = new XML::DOM::Parser;
	 my $dom = $parser->parsefile ("$root/tematiche/$nome/$title.xml");
	 my $sl = $dom->getDocumentElement();

	 if ($pro1){
		my $pr1 = $dom->createElement("pro");
		$pr1->addText($pro1);
		$sl->appendChild($pr1);
	 }
	 if ($pro2){
		my $pr2 = $dom->createElement("pro");
		$pr2->addText($pro2);
		$sl->appendChild($pr2);
	 }
	 if ($pro3){
		my $pr3 = $dom->createElement("pro");
		$pr3->addText($pro3);
		$sl->appendChild($pr3);
	 }

	 if ($con1){
		my $cn1 = $dom->createElement("contro");
		$cn1->addText($con1);
		$sl->appendChild($cn1);
	 }
	 if ($con2){
		my $cn2 = $dom->createElement("contro");
		$cn2->addText($con2);
		$sl->appendChild($cn2);
	 }
	 if ($con3){
		my $cn3 = $dom->createElement("contro");
		$cn3->addText($con3);
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
  $dsc->addText($opz);
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
	 $txt->addText($domn);
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
    <form action="/cgi-bin/add_dom.pl" method="post">
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
EOF
    print "<div class=\"btn\"><a href=\"/cgi-bin/add_sol.pl\">";
	 print "<input class=\"ok\" type=\"button\" value=\"Aggiungi un'altra soluzione\"/></a></div>";
    print "<div class=\"btn\"><a href=\"/cgi-bin/tematica.pl?ref=$nome\">";
	 print "<input class=\"ok\" type=\"button\" value=\"Termina\"/></a></div>";
}

print_doc_start("Aggiungi domanda");
if (get_user_name() eq 'admin'){
  add();
  if ($domn){
	 add_domn();
  }
  form();
}
else {
  not_admin();
}
print_doc_end();
