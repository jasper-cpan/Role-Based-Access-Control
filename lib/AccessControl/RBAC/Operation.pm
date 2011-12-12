package AccessControl::RBAC::Operation;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

extends "AccessControl::RBAC::PersistableObject";

__PACKAGE__->register_name('operation');

has 'operation_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    is_primary_key => 1,
    predicate => 'has_operation_id',

);


has 'operation_name' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);



__PACKAGE__->meta->make_immutable;

1;
