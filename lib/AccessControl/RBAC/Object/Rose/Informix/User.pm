package AccessControl::RBAC::Object::Rose::Informix::User;

use Moose;
use namespace::autoclean;

use Amethyst::RBAC::DB::User;

extends 'AccessControl::RBAC::Object::Rose';

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Amethyst::RBAC::DB::User',
    handles => 'AccessControl::RBAC::Interface::User',
);

sub build_adaptee
{
    my $class = shift;
    return Amethyst::RBAC::DB::User->new(@_);
}


with 'AccessControl::RBAC::Interface::User';

__PACKAGE__->meta->make_immutable;

1;
