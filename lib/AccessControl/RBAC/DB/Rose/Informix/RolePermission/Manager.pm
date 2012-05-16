package AccessControl::RBAC::DB::Rose::Informix::RolePermission::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::RolePermission;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::RolePermission' }

__PACKAGE__->make_manager_methods('role_permission');

1;

