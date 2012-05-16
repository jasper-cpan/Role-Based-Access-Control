package AccessControl::RBAC::DB::Rose::Informix::ResourceType::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::ResourceType;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::ResourceType' }

__PACKAGE__->make_manager_methods('resource_type');

1;

