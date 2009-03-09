#!/usr/bin/perl

use strict;
use warnings;
do "base.pl";

print_doc_start("Suggerimenti");

print <<'EOF';
  <h1> Mandaci un suggerimento </h1>
  <form method="POST" action="/cgi-bin/invia-sugg.pl">
    <p> <label for="sugg"> Suggerimento: </label> </p>
    <p> <textarea name="sugg" cols="80" rows="20"></textarea> </p>
    <input type="submit" value="Invia" />
  </form>
EOF

print_doc_end();
