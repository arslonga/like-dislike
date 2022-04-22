package Vote::Controller::Post;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(trim encode decode);
use Session;
use SessCheck;

#------------------------------
sub main{
#------------------------------
my $self = shift;
$self->render();
}#-------------

#------------------------------
sub index{
#------------------------------
my $self = shift;

$self->render();
}#-------------

#------------------------------
sub article{
#------------------------------
my $self = shift;
my $id = $self->stash('id');
my($nickname, $status, $client_check, $user_id, $title_alias);

eval{
$nickname = $self->session('client')->[0]; 
$user_id = $self->session('client')->[2]; 
};
$client_check = SessCheck->client( $self, $nickname );
if( !$client_check ){
    $status = ' disabled';
}
$title_alias = (split(/\//, $self->req->url))[1];
my $data = $self->db->select( 'posts', ['*'], {id => $id} )->hash;

$self->render( 
dat             => $data,
section_ident   => $title_alias,
id              => $id,
like_id         => 'like_'.$title_alias.'_'.$id,
unlike_id       => 'unlike_'.$title_alias.'_'.$id,
client_id       => $user_id,
unlike_btn_name => 'unlike'.$title_alias.'_'.$id,
like_btn_name   => 'like'.$title_alias.'_'.$id,
status          => $status,
liked_cnt       => $data->{liked} || 0,
unliked_cnt     => $data->{unliked} || 0
);
}#-------------

#------------------------------
sub auth{
#------------------------------
my $self = shift;

if($self->param('signin') && $self->param('nickname') && $self->param('pass')){
  my $id = $self->db->select( 'ausers', ['id'], {login => $self->param('nickname'), pass => $self->param('pass')} )->hash->{id};
  Session->user( $self, $self->param('nickname'), $self->param('pass'), $id );
}
if($self->param('exit')){
  Session->client_expire( $self );
}

$self->redirect_to( $self->param('redirect_to') );
}#-------------

#------------------------------
sub static{
#------------------------------
my $self = shift;
say 'PARAM = ', $self->param('page');

$self->reply->static('static/index.html');
}#-------------

#------------------------------
sub _static{
#------------------------------
my $self = shift;
say 'PARAM = ', $self->param('page');

$self->render('static/index');
}#-------------

1;