package AccessControl::RBAC::Interface::User;

use Moose::Role;
use namespace::autoclean;

# attribute method
requires qw/user_id login_name password/;

# save/load
requires qw/save load/;

1;
