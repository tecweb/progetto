#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';


use CGI qw( :standard );
use XML::DOM;
use HTML::Entities;

print_doc_start("Invio commento","Pagina di invio commenti");
 
my $tem_dir = get_session()->param('~tem_dir');		#directory della tematica specifica
my $tem = basename($tem_dir);
my $user = get_user_name() || "anonymous";	#nome dell'utente se ha effettuato il login, altrimenti anonimo
my $comm = param('comm');	#contenuto del commento

if($user eq "anonymous") {
	print <<'EOF';
<p> <strong>Invio non riuscito</strong> </p>
<p> Devi effettuare il <a href="login.pl">login</a> per poter pubblicare commenti. </p>
EOF
} 
elsif(($comm eq "") || ($comm eq " ")) {
	print <<"EOF";
<p> <strong>Invio non riuscito</strong> </p>
<p> Commento non inviato: non hai specificato nulla nel commento. </p>
<span> [<a href="scrivi_commento.pl?ref=$tem">Torna alla pagina precedente</a>] </span>
EOF
}		 
else {
	my $xml_file = "$tem_dir/index.xml";		
	my $parser = XML::DOM::Parser->new;		
	my $doc = $parser->parsefile($xml_file);
	
	my $new_comm = $doc->createElement('commento');

	my $new_username = $doc->createElement('username');
	$new_username->addText($user);
	
	(my $sec,my $min,my $ore,my $giom,my $mese,my $anno,my $gios,my $gioa,my $oraleg) = localtime(time);
	my @months = qw( 01 02 03 04 05 06 07 08 09 10 11 12 );
	$anno += 1900;
	$mese = $months[$mese];
	$giom = '0'.$giom if $giom < 10;
	my $date = join('-',$anno,$mese,$giom);
	my $new_data = $doc->createElement('data');
	$new_data->addText($date);

	my $new_voto = $doc->createElement('voto');
	$new_voto->addText(0);

	my $new_nvoti = $doc->createElement('nvoti');
	$new_nvoti->addText(0);

	my $new_testo = $doc->createElement('testo');
	$new_testo->addText(encode_entities($comm));

	$new_comm->appendChild($new_username); 
	$new_comm->appendChild($new_data);
	$new_comm->appendChild($new_voto);
	$new_comm->appendChild($new_nvoti);
	$new_comm->appendChild($new_testo);

	$doc->getElementsByTagName('tematica')->item(0)->appendChild($new_comm);

	$doc->printToFile($xml_file);

	print <<'EOF';
   <p class="successo"> <strong>Commento pubblicato con successo</strong> </p>
EOF
}

print <<"EOF";
   <span> [<a href="commenti.pl?ref=$tem"> Torna ai commenti </a>] </span>
EOF

print_doc_end();
