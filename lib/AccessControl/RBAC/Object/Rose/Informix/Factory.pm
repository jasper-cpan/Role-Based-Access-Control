package AccessControl::RBAC::Object::Rose::Informix::Factory;

use Moose;
use namespace::autoclean;

extends 'AccessControl::RBAC::Object::Rose::Factory';


__PACKAGE__->register_class('User', 'AccessControl::RBAC::Object::Rose::Informix::User');

__PACKAGE__->register_class('Role', 'AccessControl::RBAC::Object::Rose::Informix::Role');


__PACKAGE__->meta()->make_immutable();

1;
