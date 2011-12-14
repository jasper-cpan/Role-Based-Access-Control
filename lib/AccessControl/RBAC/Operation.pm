package AccessControl::RBAC::Operation;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('operation');
__PACKAGE__->primary_key('operation_id');


__PACKAGE__->register_name('operation');

has 'operation_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
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
