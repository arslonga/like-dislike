package Session;
use Mojo::Base -base;

#-------------------------------------
sub user {
#-------------------------------------
my($self, $c, $login, $password, $id) = @_;

$c->session( client => [$login, $password, $id], expiration => 120);
$c->cookie( client => $login.','.$id, {expires => time + 120} );

return 1;
}#---------------

#-------------------------------------
sub voting {
#-------------------------------------
my($self, $c, $user_vote_id, $title_alias_and_id) = @_;
$c->signed_cookie( $user_vote_id => $title_alias_and_id, {expires => time + 120});

return 1;
}#---------------

#-------------------------------------
sub client_expire {
#-------------------------------------
my($self, $c) = @_;
delete $c->session->{'client'};
return 1;
}#---------------
1;