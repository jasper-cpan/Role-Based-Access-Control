package AccessControl::RBAC::Permission;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

extends "AccessControl::RBAC::PersistableObject";

__PACKAGE__->register_name('permission');

has 'permission_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    is_primary_key => 1,
    predicate => 'has_permission_id',

);


has 'permission_name' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);

has 'resource_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
);

has 'operation_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
);



__PACKAGE__->meta->make_immutable;

1;
