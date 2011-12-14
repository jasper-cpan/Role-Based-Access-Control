package AccessControl::RBAC::Persistence::Provider::FileBased;

use Moose;
use namespace::autoclean;

use List::Util qw();
use YAML::Syck;
use Try::Tiny;

use Data::Dumper;

extends 'AccessControl::RBAC::Persistence::Provider';

with 'AccessControl::RBAC::Persistence::Role::PersistenceProvider';

use constant KEY_SEPARATOR   => '|';


has 'cache' => (
    is        => 'ro',
    isa       => 'HashRef',
    default   => sub { {} },
);


sub get_name_by_class
{
    my ($self,$object) = @_;
    my $class_name = blessed $object;
    if(!$class_name) {
        if(!$object || ref $object) {
            die "Invalid class name";
        }
        $class_name = $object;
    }

    my $data = $self->registry->{by_class_name}{$class_name};
    if(!$data || !exists $data->{logical_name}) {
        die "Logical name is not defined for class '$class_name'";
    }
    return ($data->{logical_name},$data->{physical_name}) if wantarray;
    return $data->{logical_name};
}


sub persist
{
    my ($self,$object) = @_;
    my $logical_name = $self->get_name_by_class($object);
    $self->load_file($logical_name);
    unless($object->primary_key_has_value) {
        die "Auto increament doesn't support for composite key." if($object->is_composite_primary_key());
        my ($key_name) = $object->primary_key();
        my $value = $self->_get_max_value($logical_name,$key_name);
        $object->primary_key_value(defined $value?$value+1:1);
    }
    $self->add_to_cache($logical_name,[$object->primary_key()],$object->persistable_attribute_values());
    $self->save_file($logical_name);
}


sub get_object_hash_key
{
    my ($self,@vals) = @_;
    my $ks = KEY_SEPARATOR;
    # double the separator if value contains the separator
    map { s/\Q$ks\E/$ks$ks/g if defined $_ } @vals;
    return join($ks, @vals);

}

sub new_persistable_object
{
    my $self = shift;
    my $logical_name = shift;

    #TODO: do some check here
    my $class = $self->registry->{by_logical_name}{$logical_name}{class};
    $class->new(@_);
}

sub find
{
    my ($self,$logical_name,$data) = @_;

    #TODO: do some check here
    my $class = $self->registry->{by_logical_name}{$logical_name}{class};


    $self->load_file($logical_name);
    my @pks = $class->primary_key();
    if(@pks > 1 && ref $data ne 'HASH') {
        die "$class contains composite primary key. Please provide a HASHREF as parameter.";
    }
    elsif(@pks == 1) {
        $data = { $pks[0] => "$data" };
    }
    else {
        die "Invalid parameter";
    }
    my $storage = $self->cache->{$logical_name};

    my $object_id = $self->get_object_hash_key(map { $data->{$_} } @pks);


    return undef unless(exists $storage->{$object_id});


    return $class->new($storage->{$object_id});

}

sub lookup
{
    my ($self,$logical_name,$conds) = @_;

    #TODO: do some check here
    my $class = $self->registry->{by_logical_name}{$logical_name}{class};



    $self->load_file($logical_name);
    my $data = $self->cache->{$logical_name};
    my @matched = ();
    $self->lookup_hash($data,$conds,\@matched);
    if(@matched) {
        return map { $class->new($_) } @matched;
    }
    return undef;
}


sub add_to_cache
{
    my ($self,$namespace,$key,$data) = @_;

print Dumper([$namespace,$key,$data]);
    my @pks = $key;
    if(ref $key eq 'ARRAY') {
        @pks = @$key;
    }
    elsif(ref $key) {
        die "Invalid parameter type";
    }

    my $cache = $self->cache;
    $cache->{$namespace} ||= {};
    my $storage = $cache->{$namespace};


    my $object_id = $self->get_object_hash_key(map { $data->{$_} } @pks);

    $storage->{$object_id} = $data;
}


sub lookup_hash
{
    # we expect $out is a array ref
    my ($self,$hash,$conds,$out) = @_;

    my $compare = 1;
    foreach my $key (keys %$hash) {
        if(ref $hash->{$key} eq 'HASH') {
            $compare = 0;
            $self->lookup_hash($hash->{$key},$conds,$out);
        }
    }
    if($compare) {
        my $match = 1;
        foreach my $attr_name (keys %$conds) {
            if(!exists $hash->{$attr_name}) {
                $match = 0;
                last;
            }
            my $cond = $conds->{$attr_name};
            if(ref $cond eq 'Regexp') {
                $match = $hash->{$attr_name} =~ /$cond/;
            }
            else {
                $match = $hash->{$attr_name} eq $cond;
            }
            last unless $match;
        }
        push @$out,$hash if($match);
    }
}


sub load_file
{
    my ($self,$logical_name) = @_;

    # Implemented in sub class
}


sub save_file
{
    my ($self,$logical_name) = @_;

    # Implemented in sub class

}


#TODO: be more generic?
sub _get_max_value
{
    my ($self,$namespace, $column) = @_;
    my $data = $self->cache->{$namespace};
    my $max = undef;
    foreach my $val (values %$data) {
        next unless (ref $val eq 'HASH');
        if(defined $val->{$column} ) {
            if(defined $max) {
                $max = $val->{$column} if($val->{$column}> $max);
            }
            else {
                $max = $val->{$column};
            }
        }
    }
    return $max;
}




__PACKAGE__->meta->make_immutable;

1;
