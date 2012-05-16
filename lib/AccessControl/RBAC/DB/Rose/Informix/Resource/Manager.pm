package AccessControl::RBAC::DB::Rose::Informix::Resource::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::Resource;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::Resource' }

__PACKAGE__->make_manager_methods('resource');

1;

