package AccessControl::RBAC::Interface::Role;

use Moose::Role;
use MooseX::ClassAttribute;
use namespace::autoclean;

class_has 'rbac_object_name' => (
    is => 'ro',
    isa => 'Str',
    default => 'Role',
);


# attribute method
requires qw/role_id role_name created_on/;

# save/load
requires qw/save load/;

# other methods
requires qw/add_users get_users/;

1;
