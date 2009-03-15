#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;

do "base.pl";
my $root = get_root();

my $ydate = param('ydate');
my $mdate = param('mdate');
my $ddate = param('ddate');
my $title = param('title');
my $desc = param('desc');
my $link = param('link');


sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}

sub added{
	 return ($ydate && $mdate && $ddate && $title && $desc && $link);
}

sub form(){
	 print<<'EOF';
    <form action="add_news.pl" method="post">
	 <fieldset>
	 <legend>Aggiungi news</legend>
    <div>
	   <p class="lbl"><label>Data (gg/mm/aaaa): </label> </p>
	   <p><input type="text" size="1" maxlength="2" name="ddate"/>/
      <input type="text" size="1" maxlength="2" name="mdate" />/
      <input type="text" size="3" maxlength="4" name="ydate" />
      </p>
    </div>
	 <div>
	   <p class="lbl"><label for="title"> Titolo: </label></p>
	   <p><input type="text" size="50" id="title" name="title"/></p>
	 </div>
	 <div>
	   <p class="lbl"><label for="desc"> Descrizione: </label></p>
	   <p><textarea cols="50" rows="5" id="desc" name="desc"></textarea></p>
	 </div>
	 <div>
	   <p class="lbl"><label for="link"> Link: </label></p>
	   <p><input type="text" size="50" id="link" name="link"/></p>
	 </div>
	 <div> <input class="ok" type="submit" value="Aggiungi" /> </div>
	 </fieldset>
    </form>
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
	 my $dom = $parser->parsefile ("$root/eventi/index.xml");
	 my $evn = $dom->getDocumentElement;

	 my $new = $dom->createElement("evento");
	 my $dt = $dom->createElement("data");
	 my $dtmp = $ydate."-".$mdate."-".$ddate;
	 $dt->addText($dtmp);
	 my $ttl = $dom->createElement("titolo");
	 $ttl->addText($title);
	 my $dsc = $dom->createElement("descrizione");
	 $dsc->addText($desc);
	 my $lnk = $dom->createElement("link");
	 $lnk->addText($link);

	 $new->appendChild($dt);
	 $new->appendChild($ttl);
	 $new->appendChild($dsc);
	 $new->appendChild($lnk);
	 $evn->appendChild($new);

	 $dom->printToFile("$root/eventi/index.xml");
	 print '<h2>La news &egrave; stata aggiunta con successo.</h2>';
  } or err();
}

print_doc_start("Aggiungi news");
if (get_user_name() eq 'admin'){
  if (!added()){
	 form();
  }
  else {
	 add();
  }
}
else {
  not_admin();
}
print_doc_end();

