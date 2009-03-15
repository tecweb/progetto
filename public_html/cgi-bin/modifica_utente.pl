use lib 'mymodules/share/perl/5.8/';
use CGI qw( :standard );
use CGI::Session;
use XML::DOM;
use XML::XPath;
use Digest::MD5 qw( md5_hex );
use Email::Valid;

do "base.pl";

my $pass1 = param('password');
my $pass2 = param('password2');
my $email = param('email');

my $session = new CGI::Session();
$session->expire('+2h');
my $cookie = CGI::Cookie->new(-name=>$session->name, -value=>$session->id);
my $user = $session->param('~username');

sub check {
  unless (defined $user) {
    return 'Non hai effettuato il <a href="login.pl">login</a>.';
  }
  unless (defined $pass1 && $pass1 eq $pass2) {
    return 'Le password non coincidono.';
  }
  if ($email && !Email::Valid->address($email)) {
    return "L'indirizzo email ($email) non &egrave; valido.";
  }
  return 0;
}

sub build_error {
  my $err = shift @_;
  $session->param('~errore-modifica', $err);
  $session->flush();
}

my $err = check();

if ($err) {
  build_error($err);
} else {
  eval {
    my $parser = new XML::DOM::Parser;
    my $file = get_root() . "/utenti.xml";
    my $doc = $parser->parsefile($file);
    foreach ($doc->getElementsByTagName('utente')) {
      if ($_->getElementsByTagName('username')->item(0)->getFirstChild()->getNodeValue() eq $user) {
        if ($pass1) {
          $_->getElementsByTagName('md5pass')->item(0)->getFirstChild()->setNodeValue(md5_hex($pass1));
        }
        if ($email) {
          $_->getElementsByTagName('email')->item(0)->getFirstChild()->setNodeValue($email);
        }
        last;
      }
    }
    $doc->printToFile($file);
    $session->param('~modifica-ok', 1);
    $session->flush();
    1;
  } or build_error('Errore interno durante la modifica.');
}

## redirect
print header(-cookie=>$cookie, -Location => "gestione_utente.pl");
