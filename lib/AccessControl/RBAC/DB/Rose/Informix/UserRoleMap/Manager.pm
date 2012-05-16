package AccessControl::RBAC::DB::Rose::Informix::UserRoleMap::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::UserRoleMap;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::UserRoleMap' }

__PACKAGE__->make_manager_methods('user_role_map');

1;

