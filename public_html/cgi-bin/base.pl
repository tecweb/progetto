#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI::Session;
use File::Basename;

my $session = new CGI::Session();

my $id = $session->id();

$session->expire('+2h'); # two hours of inacticity

print $session->header();

sub user_name {
    return $session->param('~username');
}

## get user priviledge level
sub user_priv {
    my $name = user_name();
    if ($name eq 'admin') {
        return 2;
    } elsif (!$name) {
        return 0;
    } else {
        return 1;
    }
}

sub print_head {
	 my $page_name = shift @_;

	 print <<'EOF';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
  <head>
EOF
	 print "<title> $page_name - Piazza Marconi Zero </title>";
	 print <<'EOF';
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <meta name="title" content="commenti - gruppo 'Piazza Marconi Zero'"/>
    <meta name="description" content="pagina dedicata ai commenti degli iscritti al 
      gruppo di Valdobbiadene 'piazza Marconi zero'"/>
    <meta name="keywords" content="Valdobbiadene, gruppo, giovani, commenti"/>
    <meta name="language" content="italian it"/>
    <link href="../style.css" rel="stylesheet" type="text/css" media="all"/>
  </head>
EOF
}

sub print_header {
	 print <<'EOF';
    <div id="header">
      <span id="logo"></span>
      <h1 id="intestazione"> Piazza Marconi Zero </h1>
    </div>
    <div id="login">
      <h4> Login </h4>
    <form method="POST" action="/cgi-bin/login.pl">
      <fieldset>
        <p>
	  <label for="username"> Username: </label>
          <input type="text" size="20" id="username" />
	</p>
        <p>
          <label for="password"> Password: </label>
          <input type="password" size="20" maxlength="256" id="password" />
        </p>
      <input type="submit" value="Login" />
      </fieldset>
      <!-- TODO: aggiungere creazione account -->
    </form>
    </div>	 
EOF
}

my $doc_root = '../';
my $tem_dir = "$doc_root/tematiche/";

sub load_tem {
    my @files = glob "$tem_dir/*";
    foreach (@files) {
        $_ = basename($_);
        print "<dd> <a href=\"/cgi-bin/tematica.pl?ref=$_\"> $_ </a> </dd>";
    }
}

sub print_nav {
	 print <<'EOF';
	 <div id="nav_bar">
		  <!--SEZIONE DA RISISTEMARE-->
		  <dl>
          <dt class="menu_title"> Naviga </dt>
		    <dd><a href="home.html"> Home </a></dd>
		    <dd><a href="info.html"> Chi siamo </a></dd>
          <dt class="menu_title"> Tematiche </dt> 
EOF
	 load_tem();
	 print <<'EOF';
		    <dt class="menu_title"> Suggerimenti </dt>
		    <dd><a href="#"> Scrivici </a></dd>
		  </dl> 
	 </div>
EOF
}
