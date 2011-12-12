package AccessControl::RBAC::PersistenceFactory;

use MooseX::Singleton;
use namespace::autoclean;

has 'config' => (
    is  => 'rw',
    isa => 'HashRef',
    required => 1,
    #TODO: Fix me
    default => sub {
        {
            class => 'AccessControl::RBAC::Persistence::Provider::YAML',
            init_args => {
            },
        }
    },

);

has 'current_provider' => (
    is  => 'rw',
    does => 'AccessControl::RBAC::Persistence::Role::PersistenceProvider',
    required => 1,
    lazy => 1,
    builder => 'build_persistence_provider',
);

sub build_persistence_provider
{
    my $self = shift;
    my $config = $self->config;
    my $provider_class = $config->{class};
    my $init_args = $config->{init_args};

    unless(eval "require $provider_class") {
        die "Fail to load '$provider_class', $@";
    }
    return $provider_class->new($init_args);
}


__PACKAGE__->meta->make_immutable;
1;
