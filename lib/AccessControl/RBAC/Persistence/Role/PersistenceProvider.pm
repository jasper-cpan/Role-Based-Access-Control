package AccessControl::RBAC::Persistence::Role::PersistenceProvider;

use Moose::Role;
use namespace::autoclean;

requires 'persist';

#requires 'load';

1;
