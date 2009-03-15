#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use CGI::Session;

my $tem = param('ref');	
my $tem_dir = get_tem_dir().$tem;	#directory della tematica specifica

print_doc_start("Scrivi commento","Pagina per scrivere i propri commenti");

get_session()->param('~tem_dir',$tem_dir);

print <<"EOF";
	<h2> Esprimi la tua opinione </h2>
	<p> Effettua il <a href="login.pl">login</a> se non l&apos;hai ancora fatto. </p>
	<p> <a href="commenti.pl?ref=$tem">Torna alla pagina precedente</a> </p>
	<form method="post" action="pubblica_commento.pl">
		<div> <label for="comm"> Commento: </label> </div>
		<div> <textarea id="comm" name="comm" cols="80" rows="10"></textarea> </div>
		<div> <input class="ok" type="submit" value="Invia" /> </div>
	</form>
EOF

print_doc_end();
