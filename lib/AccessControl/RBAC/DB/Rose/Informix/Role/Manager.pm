package AccessControl::RBAC::DB::Rose::Informix::Role::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::Role;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::Role' }

__PACKAGE__->make_manager_methods('role');

1;

