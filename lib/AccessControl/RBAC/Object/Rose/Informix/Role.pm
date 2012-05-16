package AccessControl::RBAC::Object::Rose::Informix::Role;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::ObjectManager;

extends 'AccessControl::RBAC::Object::Rose::Role';

has '+adaptee' => (isa     => 'AccessControl::RBAC::DB::Rose::Informix::Role');

__PACKAGE__->meta->make_immutable;

1;
