package AccessControl::RBAC::RolePermission;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;


with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('role_permission');
__PACKAGE__->primary_key('role_id', 'permission_id');


has 'role_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);

has 'permission_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    required=> 1,
);


has 'is_denied' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);


__PACKAGE__->meta->make_immutable;

1;
