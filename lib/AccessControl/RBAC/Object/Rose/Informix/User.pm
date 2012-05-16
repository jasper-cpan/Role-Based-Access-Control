package AccessControl::RBAC::Object::Rose::Informix::User;

use Moose;
use namespace::autoclean;

extends 'AccessControl::RBAC::Object::Rose::User';

use Amethyst::RBAC::DB::User;
has '+adaptee' => (isa     => 'Amethyst::RBAC::DB::User');

__PACKAGE__->meta->make_immutable;

1;
