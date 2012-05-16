package AccessControl::RBAC::Interface::User;

use Moose::Role;
use namespace::autoclean;

use MooseX::ClassAttribute;

class_has 'rbac_object_name' => (
    is => 'ro',
    isa => 'Str',
    default => 'User',
);

# attribute method
requires qw/user_id login_name password/;

# save/load
requires qw/save load/;

1;
