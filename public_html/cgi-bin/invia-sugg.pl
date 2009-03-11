#!/usr/bin/perl

use strict;
use warnings;

do "base.pl";

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use XML::DOM;

print_doc_start("Invio suggerimento", "pagina che permette di inviare suggerimenti all'amministratore del sito", "suggerimenti");

my $sugg = param('sugg');
my $user = get_user_name() || "anonymous";

if (defined $sugg) {
  my $xml_file = get_root() . '/suggerimenti.xml';
  my $parser = XML::DOM::Parser->new;
  my $doc = $parser->parsefile($xml_file);

  my $new_sugg = $doc->createElement('suggerimento');
  my $txt = $doc->createElement('testo');
  $txt->addText($sugg);
  my $u = $doc->createElement('utente');
  $u->addText($user);
  $new_sugg->appendChild($txt);
  $new_sugg->appendChild($u);

  $doc->getElementsByTagName('suggerimenti')->item(0)->appendChild($new_sugg);

  $doc->printToFile($xml_file);

  print <<'EOF';
    <p class="successo"> Suggerimento inviato con successo </p>
EOF
} else {
  print <<'EOF';
    <p class="errore"> Errore durante invio suggerimento: suggerimento non specificato </p>
EOF
}

print_doc_end();
