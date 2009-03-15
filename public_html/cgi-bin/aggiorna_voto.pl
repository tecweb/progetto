#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';

do 'base.pl';

use CGI qw( :standard);
use XML::DOM;
use XML::XPath;

print_doc_start("Votazione avvenuta","Conferma dell'avvenuta votazione");

my $session = get_session();
my $tem = $session->param('~tem');
my $tem_dir = get_tem_dir().$tem;
my $xml_file = "$tem_dir/index.xml";
my $button = param('button');

(my $voto,my $ncomm) = split(/_/,$button);

SWITCH: {
	if($voto eq 'voto-1-stella') {
		$voto = 1;
		last SWITCH;
	}
	if($voto eq 'voto-2-stelle') {
		$voto = 2;
		last SWITCH;
	}
	if($voto eq 'voto-3-stelle') {
		$voto = 3;
		last SWITCH;
	}
	if($voto eq 'voto-4-stelle') {
		$voto = 4;
		last SWITCH;
	}
}


# calcolo il nuovo voto
my $xp;
eval {
	$xp = XML::XPath->new(filename => $xml_file);
} or print "";
my $old_voto = $xp->findvalue("/tematica/commento[$ncomm]/voto/text()")->value();
my $old_nvoti = $xp->findvalue("/tematica/commento[$ncomm]/nvoti/text()")->value();

my $new_voto = (($old_voto*$old_nvoti)+$voto)/($old_nvoti+1);
my $new_nvoti = $old_nvoti+1;

# aggiorno il voto e il numero di voti
my $parser = XML::DOM::Parser->new;
my $doc = $parser->parsefile($xml_file);

my $node = $doc->getElementsByTagName('voto')->item($ncomm-1);  
$node->getFirstChild()->setNodeValue($new_voto);

my $node1 = $doc->getElementsByTagName('nvoti')->item($ncomm-1);
$node1->getFirstChild()->setNodeValue($new_nvoti);

$doc->printToFile($xml_file);

print <<"EOF";
	<p> <strong>Voto confermato</strong> </p>
	<a href="commenti.pl?ref=$tem">Torna ai commenti</a>
EOF

print_doc_end();
