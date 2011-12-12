package AccessControl::RBAC::Session;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

extends "AccessControl::RBAC::PersistableObject";

has 'session_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    is_primary_key  => 1,
    predicate => 'has_session_id',

);


has 'user' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'AccessControl::RBAC::User',
);

has 'session_token' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    #required=> 1,
);



__PACKAGE__->meta->make_immutable;

1;
