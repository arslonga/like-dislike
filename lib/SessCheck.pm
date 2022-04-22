package SessCheck;
use Mojo::Base -base;

#-------------------------------------
sub client {
#-------------------------------------
my($c, $self, $nickname) = @_;
my $checker;

if( $nickname && $self->session('client')->[1] eq $self->db->select( 
                                                   'ausers', 
                                                   ['pass'], 
                                                   {login => $nickname} 
                                                  )->hash->{pass} ){ 
    $checker = 1;
}

return defined $checker;
}#---------------

1;