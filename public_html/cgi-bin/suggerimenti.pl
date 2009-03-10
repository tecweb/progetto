#!/usr/bin/perl

use strict;
use warnings;
do "base.pl";

print_doc_start("Suggerimenti");

print <<'EOF';
  <h1> Mandaci un suggerimento </h1>
  <form method="post" action="/cgi-bin/invia-sugg.pl">
    <p> <label for="sugg"> Suggerimento: </label> </p>
    <p> <textarea id="sugg" name="sugg" cols="80" rows="10"></textarea> </p>
    <input class="ok" type="submit" value="Invia" />
  </form>
EOF

print_doc_end();
