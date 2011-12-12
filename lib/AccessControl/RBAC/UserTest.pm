package AccessControl::RBAC::UserTest;

use Moose;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;
use AccessControl::RBAC::UserRoleMapping;

extends "AccessControl::RBAC::User";

with "AccessControl::RBAC::Persistence::Role::Persistable";


has 'test_user_col' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
);


__PACKAGE__->meta->make_immutable;

1;
