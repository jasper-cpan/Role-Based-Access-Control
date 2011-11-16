package AccessControl::RBAC::User;

use Moose;
use namespace::autoclean;


has 'login_name' => (
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);

has 'password' => (
    is      => 'rw',
    isa     => 'Str',
);


# Get active sessions of the user
sub active_sessions
{
}

# Get all roles associated to the user
sub roles
{
}


__PACKAGE__->meta->make_immutable;

1;
