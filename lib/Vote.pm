package Vote;
use Mojo::Base 'Mojolicious';

use Mojo::Util qw(trim);
use Mojo::SQLite;

#----------------------------------------
sub startup {
#----------------------------------------
  my $self = shift;
  my $config = $self->plugin('Config');
  $self->secrets( $self->config('secrets') );
  
  my $sql = Mojo::SQLite->new( $self->home->child('migrations') . '/vote.db' );
  
  $self->helper( db => sub { state $db = $sql->db } );  
  my $path = $self->home->child('migrations', 'vote.sql');  
  $sql->migrations->name('vote')->from_file($path)->migrate;
  
  my $r = $self->routes;
  
  $r->any('/get-pass')->to( 'serve#getpass' );

  $r->any('/')->to( 'post#main' )->name('main');
  $r->any('/first-section')->to( 'post#index' )->name('index');
  $r->any('/first-section/:id' => [ id => qr/[0-9]+/ ] )->to('post#article');
  $r->any('/authentication')->to( 'post#auth' );
  
  $r->any('/likeartcl')->to('voting#like');
  $r->any('/dislikeartcl')->to('voting#dislike');

}#------------
1;