package AccessControl::RBAC::DB::Rose::Informix::User::Manager;

use strict;

use base qw(Rose::DB::Object::Manager);

use AccessControl::RBAC::DB::Rose::Informix::User;

sub object_class { 'AccessControl::RBAC::DB::Rose::Informix::User' }

__PACKAGE__->make_manager_methods('user');

1;

