package AccessControl::RBAC::User;

use Moose;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;
use AccessControl::RBAC::UserRoleMapping;

with "AccessControl::RBAC::Persistence::Role::Persistable";

__PACKAGE__->register_name('user');
__PACKAGE__->primary_key('user_id');


has 'user_id' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str|Int',
    predicate => 'has_user_id',
);


has 'login_name' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
    required=> 1,
);

has 'password' => (
    traits => [qw/PersistableAttr/],
    is      => 'rw',
    isa     => 'Str',
);

has 'dummy' => (
    is      => 'rw',
    isa     => 'Str',
);

#assign role to user
sub assign_role
{
    my ($self,$role) = @_;
    my $user_role = $self->current_provider->new_persistable_object('user_role',user_id => $self->user_id, role_id => $role->role_id);
    $user_role->persist;
    return $user_role;
}

# Get active sessions of the user
sub active_sessions
{
}

# Get all roles associated to the user
sub roles
{
}


__PACKAGE__->meta->make_immutable;

1;
