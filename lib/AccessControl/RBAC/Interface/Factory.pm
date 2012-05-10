package AccessControl::RBAC::Interface::Factory;

use Moose::Role;
use namespace::autoclean;

# Create a object
requires 'create';

# Transform a object
requires 'transform';

1;
