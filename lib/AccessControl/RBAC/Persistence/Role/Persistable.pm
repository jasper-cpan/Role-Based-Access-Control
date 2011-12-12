package AccessControl::RBAC::Persistence::Role::Persistable;

use Moose::Role;
use MooseX::ClassAttribute;
use namespace::autoclean;
use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;
use AccessControl::RBAC::PersistenceFactory;


class_has primary_key => (
    is  => 'ro',
    isa => 'ArrayRef',
    reader => '_get_primary_key',
    writer => '_set_primary_key',
    lazy => 1,
    predicate => 'has_primary_key',
    builder => 'build_primary_key',
);


class_has persistable_attrs  => (
    is  => 'ro',
    isa => 'HashRef[HashRef]',
    lazy => 1,
    builder => 'build_persistable_attrs',
);

sub register_name
{
    my ($class,$logical_name,$physical_name) = @_;
    my $factory = AccessControl::RBAC::PersistenceFactory->instance;
    return $factory->current_provider->register_name($class,$logical_name,$physical_name);
}

sub build_primary_key
{
    my $class = shift;
    foreach my $base ($class->meta->superclasses) {
        if($base->can('_get_primary_key')) {
            return $base->_get_primary_key();
        }
    }
    die "Primary key of class '$class' cannot be set properly";
}

sub primary_key
{
    my $class = shift;
    if(@_ > 0) {
        if($class->has_primary_key) {
            die "Primary key of $class can only be set once.";
        }
        if(ref $_[0] eq 'ARRAY') {
            die "${class}->primary_key can only accept one ARRAY ref parameter" if(@_ > 1);
            $class->_set_primary_key(@_);
        }
        elsif(!ref $_[0]) {
            $class->_set_primary_key([@_]);
        }
        else {
            die "${class}->primary_key can only accept array or array ref parameter";
        }
    }

    my @pks = @{$class->_get_primary_key()};
    return @pks if wantarray;
    return \@pks;
}

# Static method
sub build_persistable_attrs
{
    my $class = shift;
    my $meta = $class->meta;
    my $attrs = {};
    foreach my $attr ( $meta->get_all_attributes() ) {
        next unless($attr->does('AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr'));
        $attrs->{$attr->name} = {
            #name => $attr->name,
            attr => $attr,
            reader => $attr->get_read_method,
            writer => $attr->get_write_method,
            physical_name => $attr->physical_name || $attr->name,
        };
    }
    foreach my $name ($class->primary_key) {
        die "Primary key '$name' is not defined as a persistable attribute." unless($attrs->{$name});
    }

    return $attrs;
}

# Static method
sub is_composite_primary_key
{
    my $class = shift;
    my $primary_key = $class->primary_key();
    return @$primary_key>1?1:0;
}

sub primary_key_value
{
    my ($self,@vals) = @_;
    my $attrs = $self->persistable_attrs();
    my $primary_key = $self->primary_key();
    unless(@vals) {
        # get primary key value
        foreach my $name ( @$primary_key) {
            my $reader = $attrs->{$name}{reader};
            push @vals, $self->$reader();
        }
    }
    else {
        # set primary key value
        if(@vals ne @$primary_key) {
            die "The number of values doesn't match the number of primary key columns";
        }
        my $i = 0;
        foreach my $name ( @$primary_key) {
            my $writer = $attrs->{$name}{writer};
            $self->$writer($vals[$i++]);
        }
    }
    return @vals;
}

sub primary_key_has_value
{
    my $self = shift;
    my $attrs = $self->persistable_attrs();
    foreach my $name ($self->primary_key()) {
        my $attr = $attrs->{$name}{attr};
        # any primary key is not set, return false
        return 0 unless($attr->has_value($self));
    }
    return 1;
}


sub persistable_attribute_values
{
    my $self = shift;
    my $all = shift;
    my $data = {};
    my $attrs = $self->persistable_attrs();
    foreach my $name (keys %$attrs) {
        my $attr = $attrs->{$name}{attr};
        next if(!$all && !$attr->has_value($self));
        my $reader = $attrs->{$name}{reader};
        $data->{$name} = $self->$reader;
    }
    return $data;
}

sub persist
{
    my $self = shift;

    my $factory = AccessControl::RBAC::PersistenceFactory->instance;
    return $factory->current_provider->persist($self);

}


1;
