package AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance' }

__PACKAGE__->make_manager_methods('allowed_resource_inheritance');

1;

