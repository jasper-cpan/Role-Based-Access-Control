package AccessControl::RBAC::Resource;

use Moose;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('resource');
__PACKAGE__->primary_key('resource_id');

has 'resource_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    predicate => 'has_resource_id',

);


has 'resource_name' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);



__PACKAGE__->meta->make_immutable;

1;
