package AccessControl::RBAC::Object::Rose::Informix::Role;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::ObjectManager;
use Amethyst::RBAC::DB::Role;

extends 'AccessControl::RBAC::Object::Rose';

class_has 'adaptee_class' => (
    is => 'ro',
    isa => 'Str',
    default => 'Please override in your subclass',
);

sub build_adaptee
{
    my $class = shift;
    return Amethyst::RBAC::DB::Role->new(@_);
}

sub add_assignees
{
    my ($self,@users) = @_;
    # TODO: Check user object
    $self->adaptee->add_assignees(map { $_->adaptee } @users);
}

sub get_assignees
{
    my ($self) = @_;
    return map { AccessControl::RBAC::ObjectManager->transform($_) } $self->adaptee->users();
}

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Amethyst::RBAC::DB::Role',
    handles => [qw/role_id role_name created_on save load/],
);


with 'AccessControl::RBAC::Interface::Role';

__PACKAGE__->meta->make_immutable;

1;
