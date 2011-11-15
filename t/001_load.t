# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'AccessControl::RBAC' ); }

my $object = AccessControl::RBAC->new ();
isa_ok ($object, 'AccessControl::RBAC');


