package AccessControl::RBAC::Persistence::Factory;

use MooseX::Singleton;
use namespace::autoclean;

use AccessControl::RBAC::Persistence::Memory;

has 'persister' => (
    is  => 'ro',
    does => 'AccessControl::RBAC::Persistence::Role::Persistable',
    required => 1,
    lazy => 1,
    builder => '_build_persister'
);

sub _build_persister
{
    #TODO: AccessControl::RBAC::Persistence::***Provider***::Memory
    return AccessControl::RBAC::Persistence::Memory->new;
}


__PACKAGE__->meta->make_immutable;
1;
