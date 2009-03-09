#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;

do "base.pl";
my $root = get_root();

my $parser = new XML::DOM::Parser;
my $dom = $parser->parsefile ("$root/eventi/index.xml");
my $evn = $dom->getDocumentElement;
my $titles = $dom->getElementsByTagName("titolo");
my @title = param('title');


sub not_admin {
  print <<'EOF';
	 <h1>Accesso negato!</h1>
	 <p>Eseguire il login come amministratore per accedere a questa pagina.</p>
EOF
}


sub form(){
  print<<'EOF';
    <form action="/cgi-bin/del_news.pl" method="POST">
	 <fieldset>
	 <legend>Cancella news</legend>
EOF
  for (my $i = 0; $i < $titles->getLength(); $i++){
	 my $value = $titles->item($i)->getFirstChild()->getData();
	 print
      "<p><input type=\"checkbox\" name=\"title\" value=\"$value\"/>$value</p>"
  }

		print<<'EOF';
	 <p> <input type="submit" value="Cancella" /> </p>
	 </fieldset>
    </form>
EOF
}

sub del_n{
  foreach my $ttl (@title){
	 my $node;
	 for (my $i = 0; $i < $titles->getLength(); $i++){
		if ($titles->item($i)->getFirstChild()->getData() eq $ttl){
		  $node = $titles->item($i);
		}
	 }
	 $evn->removeChild($node);
#	 $dom->printToFile("$root/eventi/index.xml");
  }
}

print_doc_start("Cancella news");
if (get_user_name() eq 'admin30'){
  del_n();
  form();
}
else {
  not_admin();
}
print_doc_end();
