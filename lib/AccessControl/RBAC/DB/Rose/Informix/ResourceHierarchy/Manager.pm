package AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy' }

__PACKAGE__->make_manager_methods('resource_hierarchy');

1;

