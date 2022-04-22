package Vote::Serve;
use Mojo::Base -base;
use Mojo::Base 'Mojolicious::Controller';

#--------------------------
sub getpass {
#--------------------------
my $self = shift;

$self->render(
phrase => $self->db->select('ausers', ['pass'], {login => $self->param('login')})->hash->{'pass'}
);
}#------

#--------------------------
sub getauthent {
#--------------------------
my $self = shift;
my($app, $sess_check) = @_;
my $redirect_to = $app->req->url;

$self = {
  'yes' => sub {
my $user = $app->session('client')->[0];
my $form=<<FORM;
<form name="auth-form" id="auth-form" action="/authentication" method="post">
    <div class="row text-right">
      <div class="col-sm-12">
        <div class="col-sm-8"></div>
        <div class="col-sm-4">
          <div class="col-sm-12 text-right">
          <h4>Hello $user</h4>
          <input type="hidden" name="redirect_to" value="$redirect_to">
          </div>
        </div>
      </div>
    </div>
  <div class="row text-right">
  <button style="margin-right: 45px" type="submit" name="exit" value="Exit" class="btn btn-info">Exit</button>
  </div>
</form>
FORM

},

  'no'  => sub {
my $users = $app->db->select('ausers', ['*'])->hashes;

my $form=<<FORM;
<form name="auth-form" id="auth-form" action="/authentication" method="post">
    <div class="row text-right">
      <div class="col-sm-12">
        <div class="col-sm-8"></div>
        <div class="col-sm-4">
          <div class="col-sm-12 text-center">
          <h3>Authentication</h3>
          <select class="form-control" name="nickname" onchange="getPassword()">
            <option selected="selected">select nickname</option>
FORM

            foreach my $item( @$users ){
              my $login = $item->{login};
              $form.=<<OPTION;
<option>$login</option>
OPTION
              
            }
$form.=<<FORM;            
          </select>
          <br>
          <input type="password" name="pass" class="form-control" id="getPassw" placeholder="Password">
          <input type="hidden" name="redirect_to" value="$redirect_to">
          </div>
        </div>
      </div>
    </div>
  <div class="row text-right">
  <br>
  <button style="margin-right: 45px" type="submit" name="signin" value="Sign In" class="btn btn-info">Sign In</button>
  </div>
</form>

<script>
function getPassword(){
let selectForm = document.forms['auth-form'].elements['nickname'];
let index = selectForm.selectedIndex;
console.log(selectForm.options[index].value);
let nickname = selectForm.options[index].value;

let xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
     if (this.readyState == 4 && this.status == 200) {
      document.forms['auth-form'].elements['getPassw'].value = this.responseText;
      console.log(document.forms['auth-form'].elements['getPassw'].value);
    }
  };
  xhttp.open("POST", "/get-pass?login=" + nickname, true);
  xhttp.send();

}
</script>
FORM

}
};

return $self->{$sess_check}->();
}#-----------

1;