package AccessControl::RBAC::Role;

use Moose;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('role');
__PACKAGE__->primary_key('role_id');

has 'role_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    predicate => 'has_role_id',

);


has 'role_name' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);

__PACKAGE__->meta->make_immutable;

1;
