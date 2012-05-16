package AccessControl::RBAC::DB::Rose::Informix::Action::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::Action;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::Action' }

__PACKAGE__->make_manager_methods('action');

1;

