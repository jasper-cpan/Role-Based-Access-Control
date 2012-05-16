package AccessControl::RBAC::Object::Rose::Informix::Factory;

use Moose;
use namespace::autoclean;

extends 'AccessControl::RBAC::Object::Rose::Factory';


__PACKAGE__->register_class('AccessControl::RBAC::Object::Rose::Informix::User');

__PACKAGE__->register_class('AccessControl::RBAC::Object::Rose::Informix::Role');

__PACKAGE__->meta()->make_immutable();

1;
