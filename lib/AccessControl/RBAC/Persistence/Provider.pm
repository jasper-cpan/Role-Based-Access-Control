package AccessControl::RBAC::Persistence::Provider;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;
use Scalar::Util qw/blessed/;

use List::Util qw();

#TODO: remove this
use Data::Dumper;

with 'AccessControl::RBAC::Persistence::Role::PersistenceProvider';

class_has registry => (
    is        => 'ro',
    isa       => 'HashRef[HashRef]',
    default   => sub { { by_class_name => {}, by_logical_name => {} } },
);

sub register_name
{
    my ($self, $table_class,$logical_name,$physical_name) = @_;
    my $class = blessed $table_class;
    if(!$class) {
        if(!$table_class || ref $table_class) {
            die "Invalid class name";
        }
        $class = $table_class;
    }
    unless($logical_name) {
        die 'logical_name is mandatory parameter';
    }
    my $registry = $self->registry;

    #TODO: Be more robust on checking class type
    my $data =
        {
            class => $class,
            logical_name => $logical_name,
            physical_name => $physical_name || $logical_name,

        };

    $registry->{by_logical_name}{$logical_name} = $data;

    $registry->{by_class_name}{$class} = $data;

use Data::Dumper;
print Dumper($registry);
    return;
}


sub persist
{
    my ($self,$object) = @_;
}

sub remove
{
    my ($self,$object) = @_;
}

sub find
{
    my ($self,$class,$primary_key) = @_;
}

sub lookup
{
    my ($self,$class,$conds) = @_;
}


__PACKAGE__->meta->make_immutable;

1;
