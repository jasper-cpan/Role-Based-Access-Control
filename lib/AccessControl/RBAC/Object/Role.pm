package AccessControl::RBAC::Object::Role;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

use AccessControl::RBAC::ObjectManager;
use Amethyst::RBAC::DB::Role;

extends 'AccessControl::RBAC::Object';

class_has '+adaptee_class' => (default => 'Amethyst::RBAC::DB::Role');

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Amethyst::RBAC::DB::Role',
    #handles => [qw/role_id role_name created_on save load/],
    handles => 'AccessControl::RBAC::Interface::Role',
);

with 'AccessControl::RBAC::Interface::Role';

around 'add_assignees' => sub
{
    my ($orig, $self,@users) = @_;
    # TODO: Check user object
    $self->$orig(map { $_->adaptee } @users);
};

around 'get_assignees' => sub
{
    my $orig = shift;
    my $self = shift;
    my @users = $self->$orig(@_);
    return map { AccessControl::RBAC::ObjectManager->transform($_) } @users;
};


__PACKAGE__->meta->make_immutable;

1;
