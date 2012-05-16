package AccessControl::RBAC::DB::Rose::Informix::ResourceAction::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::ResourceAction;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::ResourceAction' }

__PACKAGE__->make_manager_methods('resource_action');

1;

