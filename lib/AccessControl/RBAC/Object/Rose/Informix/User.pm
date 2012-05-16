package AccessControl::RBAC::Object::Rose::Informix::User;

use Moose;
use namespace::autoclean;

extends 'AccessControl::RBAC::Object::Rose::User';

has '+adaptee' => (isa     => 'AccessControl::RBAC::DB::Rose::Informix::User');

__PACKAGE__->meta->make_immutable;

1;
