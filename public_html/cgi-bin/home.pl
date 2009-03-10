#!/usr/bin/perl

use strict;
use warnings;
do "base.pl";

use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use XML::DOM;

print_doc_start('Home', 'Homepage');

my $xml_file = get_root() . '/eventi/index.xml';
my $parser = XML::DOM::Parser->new;
my $doc = $parser->parsefile($xml_file);

print <<'EOF';
    <h3> News </h3>
EOF
print_doc_end();
