package AccessControl::RBAC::DB::Rose::Informix::Session::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::Session;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::Session' }

__PACKAGE__->make_manager_methods('session');

1;

