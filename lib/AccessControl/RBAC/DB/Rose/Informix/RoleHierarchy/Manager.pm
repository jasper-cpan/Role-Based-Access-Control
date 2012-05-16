package AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy' }

__PACKAGE__->make_manager_methods('role_hierarchy');

1;

