package AccessControl::RBAC::Persistence::Provider::FileBased::XML;

use Moose;
use namespace::autoclean;

use List::Util qw();
use XML::Simple;
use Try::Tiny;

use Data::Dumper;

extends 'AccessControl::RBAC::Persistence::Provider::FileBased';

with 'AccessControl::RBAC::Persistence::Role::PersistenceProvider';


sub load_file
{
    my ($self,$logical_name) = @_;

    my $physical_name = $self->registry->{by_logical_name}{$logical_name}{physical_name};

    #TODO: add real path
    my $filename = "$physical_name.xml";
    my $data = {};
    if(-r $filename) {
        try {
                my $data = XMLin($filename);
                die "Incompatible file format ($filename)" if(ref $data ne 'HASH');
                $self->cache->{$logical_name} = $data;
            }
        catch {
            #FIXME:
            print "failed name = $filename\n";
            die $_;
        };

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
    my $filename = "$physical_name.xml";

    try {
        my $xml = XMLout($self->cache->{$logical_name});
        if(open(OUTPUT,">", $filename)) {
            print OUTPUT $xml;
            close(OUTPUT);
        }
        else {
            die "Cannot open '$filename' to write.";
        }
    }
    catch {
        print "savvving file ----------\n" . Dumper($self->cache->{$logical_name});
        die $_;
    };
    return;
}




__PACKAGE__->meta->make_immutable;

1;
