package AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;

use Moose::Role;
use namespace::autoclean;

has 'physical_name' => (
    is      => 'ro',
    isa     => 'Str',
);


package Moose::Meta::Attribute::Custom::Trait::PersistableAttr;
sub register_implementation {'AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr'}

1;
