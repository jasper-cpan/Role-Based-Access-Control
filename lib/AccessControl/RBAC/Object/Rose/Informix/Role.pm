package AccessControl::RBAC::Object::Rose::Informix::Role;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::ObjectManager;

extends 'AccessControl::RBAC::Object::Rose::Role';

use Amethyst::RBAC::DB::Role;
has '+adaptee' => (isa     => 'Amethyst::RBAC::DB::Role');


__PACKAGE__->meta->make_immutable;

1;
