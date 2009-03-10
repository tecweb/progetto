#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;

do "base.pl";
my $root = get_root();

my $date = param('date');
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
	 return ($date && $title && $desc && $link);
}

sub form(){
	 print<<'EOF';
    <form action="/cgi-bin/add_news.pl" method="POST">
	 <fieldset>
	 <legend>Aggiungi news</legend>
	 <p>
	   <label for="Data"> Data: </label> <br/>
	   <input type="text" size="10" name="date" />
	 </p>
	 <p>
	   <label for="Titolo"> Titolo: </label><br/>
	   <input type="text" size="50" name="title"/>
	 </p>
	 <p>
	   <label for="Descrizione"> Descrizione: </label><br/>
	   <textarea cols="50" rows="5" name="desc"></textarea>
	 </p>
	 <p>
	   <label for="Link"> Link: </label><br/>
	   <input type="text" size="50" name="link"/>
	 </p>
	 <p> <input class="ok" type="submit" value="Aggiungi" /> </p>
	 </fieldset>
    </form>
EOF
}

sub add{
  my $parser = new XML::DOM::Parser;
  my $dom = $parser->parsefile ("$root/eventi/index.xml");
  my $evn = $dom->getDocumentElement;

  my $new = $dom->createElement("evento");
  my $dt = $dom->createElement("data");
  $dt->addText($date);
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
}

print_doc_start("Aggiungi news");
if (get_user_name() eq 'admin'){
  if (!added()){
	 form();
  }
  else {
	 add();
	 print '<h2>La news &egrave; stata aggiunta con successo.</h2>';
  }
}
else {
  not_admin();
}
print_doc_end();

