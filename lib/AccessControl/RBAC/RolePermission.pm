package AccessControl::RBAC::RolePermission;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

extends "AccessControl::RBAC::PersistableObject";

__PACKAGE__->register_name('role_permission');


has 'role_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    is_primary_key => 1,
    required=> 1,
);

has 'permission_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    is_primary_key => 2,
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
