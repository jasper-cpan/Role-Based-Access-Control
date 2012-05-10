package AccessControl::RBAC::Interface::Role;

use Moose::Role;
use namespace::autoclean;

# attribute method
requires qw/role_id role_name created_on/;

# save/load
requires qw/save load/;

# other methods
requires qw/add_assignees get_assignees/;

1;
