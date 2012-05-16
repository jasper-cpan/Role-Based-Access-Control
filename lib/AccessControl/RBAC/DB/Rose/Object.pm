package AccessControl::RBAC::DB::Rose::Object;

use strict;

use base 'Rose::DB::Object';

our $VERSION = '0.01';

sub init_db { AccessControl::RBAC::DB::Rose->new() }

1;
