package AccessControl::RBAC::UserRoleMapping;

use Moose;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('user_role');
__PACKAGE__->primary_key('user_id','role_id');

has 'user_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
);

has 'role_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
);


has 'updated_on' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    default => sub { scalar localtime },
);

__PACKAGE__->meta->make_immutable;

1;
