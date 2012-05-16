package AccessControl::RBAC::Object::Rose::User;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

extends 'AccessControl::RBAC::Object::Rose';

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Rose::DB::Object',
    handles => 'AccessControl::RBAC::Interface::User',
);

with 'AccessControl::RBAC::Interface::User';

__PACKAGE__->meta->make_immutable;

1;
