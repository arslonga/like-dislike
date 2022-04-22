package Vote::Voting;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util qw(trim encode decode);
use Mojo::Cookie;
use Session;

#---------------------------------
sub like {
#---------------------------------
my $self = shift;
my($nickname, $status);
eval{
$nickname = $self->session('client')->[0];  
};
my $client_check = SessCheck->client( $self, $nickname );

my $title_alias = $self->param('title_alias');
my $article_id  = $self->param('article_id');
my $user_id     = $self->param('user_id');

if( !$client_check ){
    $status = ' disabled';
}

my $like_count = $self->db->select( 'posts', ['liked'], {id => $article_id} )->hash->{liked};
my $unlike_count = $self->db->select( 'posts', ['unliked'], {id => $article_id} )->hash->{unliked};
my $like_cookie_name = 'like_user'.$user_id.'_'.$title_alias.'_'.$article_id;
my $unlike_cookie_name = 'unlike_user'.$user_id.'_'.$title_alias.'_'.$article_id;

if( !$self->signed_cookie( $like_cookie_name ) && $client_check ){
    ++$like_count;
    $self->db->update( 'posts', {'liked' => $like_count}, {'id' => $article_id} );
}

if( $self->signed_cookie( $unlike_cookie_name ) ){
    --$unlike_count;
    $self->db->update( 'posts', {'unliked' => $unlike_count}, {'id' => $article_id} );
    $self->signed_cookie( $unlike_cookie_name => '', {expires => 1});
}

Session->voting( $self, 
                 'like_user'.$user_id.'_'.$title_alias.'_'.$article_id, 
                 $title_alias.'_'.$article_id 
               );

$self->render(
template        => 'voting/vote',
section_ident   => $title_alias,
id              => $article_id,
like_id         => 'like_'.$title_alias.'_'.$article_id,
unlike_id       => 'unlike_'.$title_alias.'_'.$article_id,
client_id       => $user_id,
unlike_btn_name => 'unlike'.$title_alias.'_'.$article_id,
like_btn_name   => 'like'.$title_alias.'_'.$article_id,
status          => $status,
liked_cnt       => $like_count,
unliked_cnt     => $unlike_count
);
}#---------------

#---------------------------------
sub dislike {
#---------------------------------
my $self = shift;
my($nickname, $status);
eval{
$nickname = $self->session('client')->[0];  
};
my $client_check = SessCheck->client( $self, $nickname );

my $title_alias = $self->param('title_alias');
my $article_id  = $self->param('article_id');
my $user_id     = $self->param('user_id');

if( !$client_check ){
    $status = ' disabled';
}

my $unlike_count = $self->db->select( 'posts', ['unliked'], {id => $article_id} )->hash->{unliked};
my $like_count = $self->db->select( 'posts', ['liked'], {id => $article_id} )->hash->{liked};
my $like_cookie_name = 'like_user'.$user_id.'_'.$title_alias.'_'.$article_id;
my $unlike_cookie_name = 'unlike_user'.$user_id.'_'.$title_alias.'_'.$article_id;

if( !$self->signed_cookie( $unlike_cookie_name ) && $client_check ){
    ++$unlike_count;
    $self->db->update( 'posts', {'unliked' => $unlike_count}, {'id' => $article_id} );
}

if( $self->signed_cookie( $like_cookie_name ) ){
    --$like_count;
    $self->db->update( 'posts', {'liked' => $like_count}, {'id' => $article_id} );
    $self->signed_cookie( $like_cookie_name => '', {expires => 1});
}

# Store session for a specifics user and post
Session->voting( $self, 
                 'unlike_user'.$user_id.'_'.$title_alias.'_'.$article_id, 
                 $title_alias.'_'.$article_id );

$self->render(
template        => 'voting/vote',
section_ident   => $title_alias,
id              => $article_id,
like_id         => 'like_'.$title_alias.'_'.$article_id,
unlike_id       => 'unlike_'.$title_alias.'_'.$article_id,
client_id       => $user_id,
unlike_btn_name => 'unlike'.$title_alias.'_'.$article_id,
like_btn_name   => 'like'.$title_alias.'_'.$article_id,
status          => $status,
unliked_cnt     => $unlike_count,
liked_cnt       => $like_count
);
}#---------------
1;