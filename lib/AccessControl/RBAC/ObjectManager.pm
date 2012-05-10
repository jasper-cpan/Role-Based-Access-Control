package AccessControl::RBAC::ObjectManager;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

class_has factory => (
    is  => 'rw',
    does => 'AccessControl::RBAC::Interface::Factory',
    predicate => 'initialized',
    handles => 'AccessControl::RBAC::Interface::Factory',
);

__PACKAGE__->meta()->make_immutable();

1;
