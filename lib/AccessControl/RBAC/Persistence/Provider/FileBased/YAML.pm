package AccessControl::RBAC::Persistence::Provider::FileBased::YAML;

use Moose;
use namespace::autoclean;

use List::Util qw();
use YAML::Syck;
use Try::Tiny;

use Data::Dumper;

extends 'AccessControl::RBAC::Persistence::Provider::FileBased';

with 'AccessControl::RBAC::Persistence::Role::PersistenceProvider';


sub load_file
{
    my ($self,$logical_name) = @_;

    my $physical_name = $self->registry->{by_logical_name}{$logical_name}{physical_name};

    #TODO: add real path
    my $filename = "$physical_name.yaml";
    my $data = {};
    if(-r $filename) {
        $data = LoadFile($filename);
        die "Incompatible file format ($filename)" if(ref $data ne 'HASH');
        $self->cache->{$logical_name} = $data;
    }
    else {
        $self->cache->{$logical_name} = {};
    }
    return;
}


sub save_file
{
    my ($self,$logical_name) = @_;

    my $physical_name = $self->registry->{by_logical_name}{$logical_name}{physical_name};

    #TODO: add real path
    my $filename = "$physical_name.yaml";

    DumpFile($filename,$self->cache->{$logical_name});
    return;
}




__PACKAGE__->meta->make_immutable;

1;
