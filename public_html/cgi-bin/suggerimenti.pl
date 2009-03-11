#!/usr/bin/perl

use strict;
use warnings;
do "base.pl";

print_doc_start("Suggerimenti");

print <<'EOF';
  <h1> Mandaci un suggerimento </h1>
  <form method="post" action="/cgi-bin/invia-sugg.pl">
    <div> <label for="sugg"> Suggerimento: </label> </div>
    <div> <textarea id="sugg" name="sugg" cols="80" rows="10"></textarea> </div>
    <div> <input class="ok" type="submit" value="Invia" /> </div>
  </form>
EOF

print_doc_end();
