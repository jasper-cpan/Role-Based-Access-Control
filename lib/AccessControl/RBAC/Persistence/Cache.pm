package AccessControl::RBAC::Persistence::Cache;

use Moose;
use namespace::autoclean;
use Scalar::Util qw/blessed/;


has 'cache_switches' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Str]',
    default   => sub { {} },
    handles   => {
        set_cache_switch => 'set',
        get_cache_switch => 'get',
    },

);

has 'cache_storage' => (
    is        => 'ro',
    isa       => 'HashRef',
    default   => sub { {} },
);


sub cacheable_namespaces
{
    my ($self) = @_;
    my @names = grep($self->get_cache_switch($_),keys %{$self->cache_switches});
    return @names;
}

# Save an entry to cache
sub set
{
    my ($self,$object) = @_;

    die "Value is not blessed" unless(blessed $object);
    die "Value is not a subclass of PersistableObject" unless($object->isa('AccessControl::RBAC::PersistableObject'));


    my $namespace = $object->physical_name();

    # return if the the cache is off for the namespace
    return undef unless($self->get_cache_switch($namespace));

    # return if primay key is not set
    # TODO: should we die here?
    return undef unless($object->is_primary_key_set());

    $self->cache_storage->{$namespace} ||=
        {
            data => {},
            template_object => undef,
        };
    my $data = $self->cache_storage->{$namespace}->{data};

    my @vals = $object->primary_key_values;
    my $last_value = pop @vals;
    foreach my $val (@vals) {
        $data->{$val} ||= {};
        $data = $data->{$val};
    }
    $data->{$last_value} = $object;
    $self->cache_storage->{$namespace}->{template_object} = $object;
    return 1;
}

sub lookup_hash
{
    # we expect $out is a array ref
    my ($self,$hash,$conds,$out) = @_;

    foreach my $val (values %$hash) {
        if(ref $val eq 'HASH') {
            $self->lookup_hash($val,$conds,$out);
        }
        elsif(blessed $val) {
            my $match = 1;
            foreach my $attr_name (keys %$conds) {
                next unless($val->can($attr_name));
                # TODO: case sensive or non-sensitive?
                # TODO: potentially unsafe if the attr_name collides with a regular method
                if($val->$attr_name ne $conds->{$attr_name}) {
                    $match = 0;
                    last;
                }
            }
            push @$out,$val if($match);
        }

    }
}

# look up entry from cache
sub _lookup
{
    my ($self,$namespace,$key) = @_;
    # return if the the cache is off for the namespace
    return undef unless($self->get_cache_switch($namespace));

    my $storage = $self->cache_storage->{$namespace};

    return undef unless $storage;

    my $data = $storage->{data};
    my $tempalte_obj = $storage->{template_object};

    return undef unless $data;

    my $value;

    if( !ref($key) ) {
        $value = $data->{$key} if(exists $data->{$key});
    }
    elsif(ref $key eq 'HASH') {
        my @key_names = $tempalte_obj->primary_key_names;
        my %input = %$key;
        foreach my $name (@key_names) {
            if(defined $input{$name} && exists $data->{$input{$name}}  ) {
                my $val = delete $input{$name};
                $data = $data->{$val};
            }
            else {
                last;
            }
        }

        $value = $data
    }
    else {
        die "Invalid parameter";
    }
    return $value;

}

sub get
{
    my ($self,$namespace,$key) = @_;
    my $value = $self->_lookup($namespace,$key);
    if($value && !blessed $value) {
        die "Value is not blessed";
    }
    return $value;
}


sub lookup
{
    my ($self,$namespace,%conds) = @_;

    my $value = $self->_lookup($namespace,\%conds);
    if(ref $value eq 'HASH') {
        my $result = [];
        $self->lookup_hash($value,\%conds,$result);

        # return the list
        return @$result if(@$result);
        $value = undef;
    }

    if($value && !blessed $value) {
        die "Value is not blessed";
    }
    return $value;
}


1;
