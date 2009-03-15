#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use CGI::Session;
use XML::XPath;
use HTML::Entities;

my $tem = param('ref');	#tematica trattata
my $tem_dir = get_tem_dir().$tem;	#directory della tematica specifica

sub print_commenti {
	my $xp;
	eval {
		$xp = XML::XPath->new(filename => "$tem_dir/index.xml");
	} or print "";
	my $comments = $xp->find('/tematica/commento');
	my $i = 1;
	foreach my $comment ($comments->get_nodelist) {
		my $uname = $xp->findvalue('username/text()',$comment)->value();
		my $date = $xp->findvalue('data/text()',$comment)->value();
		(my $year,my $month,my $day) = split(/-/,$date);
		my $it_date = join('-',$day,$month,$year);
		my $voto = $xp->findvalue('voto/text()',$comment)->value();
		my $comm = decode_entities($xp->findvalue('testo/text()',$comment)->value());	
		my $cid = 'cid' . $i;
		(my $id1,my $id2,my $id3,my $id4) = ('voto-1-stella_'.$i,'voto-2-stelle_'.$i,'voto-3-stelle_'.$i,'voto-4-stelle_'.$i); 

print <<"EOF";
<fieldset class="commento">		
<p> <strong>$uname</strong> </p>
<p> $it_date </p>
<p> $comm </p>
<p> Voto attuale: $voto </p>
<form method="post" action="aggiorna_voto.pl">
<div>
	<input type="radio" id="$id1" name="button" value="$id1" checked="checked"/>
		<label for="$id1">+1 <span class="star_1"></span></label>
	<input type="radio" id="$id2" name="button" value="$id2"/>  
		<label for="$id2">+2 <span class="star_2"></span></label>
	<input type="radio" id="$id3" name="button" value="$id3"/>  
		<label for="$id3">+3 <span class="star_3"></span></label>
	<input type="radio" id="$id4" name="button" value="$id4"/>
		<label for="$id4">+4 <span class="star_4"></span></label>
	<input class="ok" type="submit" value="Vota questo post"/>  
</div>
</form>
</fieldset>
EOF
		$i++;
	}
}

print_doc_start("Commenti","Commenti tematica $tem","opinioni","commenti",$tem);

get_session()->param('~tem',$tem);

print <<"EOF";
<h2> Commenti </h2>
<p> Condividi le tue opinioni con gli altri o semplicemente leggi ci&ograve; che gli altri pensano
di questo argomento. </p>
<p> Ti ricordiamo che per inviare i tuoi commenti devi effettuare il <a href="login.pl">login</a>. </p>
<p> <a href="scrivi_commento.pl?ref=$tem">Scrivi il tuo commento</a> </p>
EOF

print_commenti();

print_doc_end();
