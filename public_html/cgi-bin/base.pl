#!/usr/bin/perl

use strict;
use warnings;

use lib 'mymodules/share/perl/5.8/';
use CGI::Session;
use File::Basename;

## globals
my $session = '';
my $doc_root = '../';
my $tem_dir = "$doc_root/tematiche/";

sub get_session {
    return $session;
}

sub get_root {
    return $doc_root;
}

sub get_tem_dir {
    return $tem_dir;
}

sub my_header {
    $session = new CGI::Session();
    #my $id = $session->id();
    $session->expire('+2h'); # two hours of inacticity
    print $session->header();
}

sub get_user_name {
    return $session->param('~username');
}

## get user priviledge level
sub user_priv {
    my $name = get_user_name();
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
  my $desc = shift @_ || "";
  my $keywords = join ', ', @_;

  print <<'EOF';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="it">
  <head>
EOF
  print "<title> $page_name - Piazza Marconi Zero </title>";
  print '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>';
  print "<meta name=\"title\" content=\"$page_name - gruppo 'Piazza Marconi Zero'\"/>";
  print "<meta name=\"description\" content=\"$desc\"/>";
  print "<meta name=\"keywords\" content=\"Valdobbiadene, gruppo, giovani, $keywords\"/>";
  print <<'EOF';
    <meta name="language" content="italian it"/>
    <link href="../style.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="../print_style.css" rel="stylesheet" type="text/css" media="print"/>
  </head>
EOF
}

sub print_header {
  print <<'EOF';
    <div id="header">
      <img src="/images/Logo.jpg" id="logo" alt="Piazza Marconi Zero" title="Logo Piazza Marconi Zero"/>
EOF

  my $user = get_user_name();
  if (defined $user) {
    print "<div id=\"login\"> Benvenuto, $user.";
    print '<a href="/cgi-bin/logout.pl"> Logout </a> </div>';
  } else {
    print '<div id="login"> Esegui il <a href="/cgi-bin/login.pl" accesskey="l"> login </a> </div>';
  }
  print "</div>"; # header
}

sub get_ordered_tem {
  my @files = glob "$tem_dir/*";
  ## ordina per data
  my @files_dates = map { my @date = stat($_); [$_, $date[9]]; } @files;
  @files = map { $_->[0] } sort { $b->[1] cmp $a->[1] } @files_dates;  
  return @files;
}

sub load_tem {
  ## num. massimo di temetiche nel menu della navigazione
  my $max_tem = 5;
  my @files = get_ordered_tem();
  my $i = 0;
  foreach (@files) {
    last if $i >= $max_tem;
    $_ = basename($_);
    my $idx = $i + 3; # tabindex
    print "<dd class=\"menu_item\"> <a href=\"/cgi-bin/tematica.pl?ref=$_\" tabindex=\"$idx\"> $_ </a> </dd>";
    $i++;
  }
  return $i;
}

sub print_nav {
	 print <<'EOF';
         <div class="hide"><a href="#corpo">Salta navigazione</a></div>
         <div id="nav_top"></div>
	 <div id="nav_bar">
	  <dl id="nav_menu">
          <dt class="menu_title"> Naviga </dt>
            <dd class="menu_item"><a href="home.pl" tabindex="1" accesskey="h"> Home </a></dd>
	    <dd class="menu_item"><a href="/cgi-bin/chisiamo.pl" tabindex="2"> Chi siamo </a></dd>
          <dt class="menu_title"> Tematiche </dt> 
EOF
	 my $next_index = load_tem() + 3;
         print "<dd id=\"all_tem\"> <a href=\"/cgi-bin/mostra_tematiche.pl?from=0\" tabindex=\"$next_index\" accesskey=\"m\"> Mostra tutte </a> </dd>";
         $next_index++;
         my $user = get_user_name() || '';
         if ($user eq 'admin') {
           print '<dt class="menu_title"> Amministrazione </dt>';
           print "<dd class=\"menu_item\"> <a href=\"/cgi-bin/admin.pl\" tabindex=\"$next_index\" accesskey=\"a\"> Amministra </a> </dd>"
         } else {
           print '<dt class="menu_title"> Suggerimenti </dt>';
           print "<dd><a href=\"/cgi-bin/suggerimenti.pl\" tabindex=\"$next_index\" accesskey=\"s\"> Scrivici </a></dd>";
         }
         print <<'EOF';
		  </dl>
	 </div>
         <div id="nav_bottom"></div>
EOF
}

sub print_foot {
  print <<'EOF';
  <div id="footer">
  <p>
    <a href="http://validator.w3.org/check?uri=referer">
      <img src="http://www.w3.org/Icons/valid-xhtml10"
           alt="XHTML 1.0 Strict Valido" height="31" width="88" />
    </a>
    <a href="http://jigsaw.w3.org/css-validator/check/referer">
      <img width="88" height="31"
           src="http://jigsaw.w3.org/css-validator/images/vcss"
           alt="CSS Valido" />
    </a>
  </p>
  </div>
EOF
}

sub print_doc_start {
    my_header();
    print_head(@_); # passa argomenti
    print "<body>";
    print_header();
    print_nav();
    print '<div id="corpo">', "\n";
}

sub print_doc_end {
    print "</div>\n";
    print_foot();
    print "</body>\n</html>\n";
}
