package AccessControl::RBAC::PersistableObject;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;
use AccessControl::RBAC::Factory;

use base qw(Class::Data::Inheritable);
__PACKAGE__->mk_classdata('physical_name');

has primary_key_attrs => (
    is  => 'ro',
    isa => 'ArrayRef[HashRef]',
    required => 1,
    lazy => 1,
    builder => '_get_primary_key_attrs',
);

sub _get_primary_key_attrs
{
    my $self = shift;
    my $class = ref $self || $self;
    my $meta = $class->meta;
    my @attrs;
    foreach my $attr ( $meta->get_all_attributes() ) {
        if($attr->does('AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr')
            && $attr->is_primary_key()
           )
        {
            push @attrs, $attr;
        }
    }
    my @primary_keys;
    foreach my $attr (sort { $a->is_primary_key() <=> $b->is_primary_key()} @attrs) {
        push @primary_keys,
             {
                name => $attr->name,
                reader => $attr->get_read_method,
                writer => $attr->get_write_method,
             };

    }

    unless (@primary_keys) {
        die "Primary key is not defined for class $class.";
    }
    return \@primary_keys;
}

sub is_composite_primary_key
{
    my $self = shift;
    my $primary_keys = $self->primary_key_attrs();
    return @$primary_keys>1?1:0;
}

sub primary_key_names
{
    my $self = shift;
    my $primary_keys;
    if(ref $self) {
        # It's an object
        $primary_keys = $self->primary_key_attrs();
    }
    else {
        # It's a class
        $primary_keys = $self->_get_primary_key_attrs();
    }

    my @names;
    foreach my $data ( @$primary_keys) {
        push @names, $data->{name};
    }
    return @names;
}

sub primary_key_values
{
    my ($self,@vals) = @_;
    my $primary_keys = $self->primary_key_attrs();
    unless(@vals) {
        foreach my $data ( @$primary_keys) {
            my $reader = $data->{reader};
            push @vals, $self->$reader();
        }
    }
    else {
        if(@vals ne @$primary_keys) {
            die "The number of values doesn't match the number of primary key columns";
        }
        my $i = 0;
        foreach my $data ( @$primary_keys) {
            my $writer = $data->{writer};
            $self->$writer($vals[$i++]);
        }
    }
    return @vals;
}

sub primary_key_has_value
{
    my $self = shift;
    my @names = $self->primary_key_names();
    my $meta = $self->meta;
    foreach my $name (@names) {
        my $attr = $meta->get_attribute($name);
        # any primary key is not set, return false
        return 0 unless($attr->has_value($self));
    }
    return 1;
}


sub persistable_attributes
{
    my $self = shift;
    my $meta = $self->meta;
    my @attrs = ();
    foreach my $attr ( $meta->get_all_attributes() ) {
        if($attr->does('AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr'))
        {
            push @attrs, $attr;
        }
    }
    return \@attrs
}

sub persistable_attribute_values
{
    my $self = shift;
    my $all = shift;
    my $data = {};
    foreach my $attr (@{$self->persistable_attributes()}) {
        next if(!$all && !$attr->has_value($self));
        my $reader = $attr->get_read_method;
        $data->{$attr->name} = $self->$reader;
    }
    return $data;
}

sub persist
{
    my $self = shift;

    my $factory = AccessControl::RBAC::Factory->instance;
    return $factory->persistence_provider->persist($self);

}


__PACKAGE__->meta->make_immutable;

1;
