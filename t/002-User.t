# -*- perl -*-

use Test::More tests => 2;

BEGIN { use_ok( 'AccessControl::RBAC::User' ); }

my $object = AccessControl::RBAC::User->new (login_name => 'test02');
isa_ok ($object, 'AccessControl::RBAC::User');


