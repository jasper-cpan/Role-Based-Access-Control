package AccessControl::RBAC::Generic;

use Moose;
use namespace::autoclean;

use AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr;
use AccessControl::RBAC::Factory;


has 'id_name' => (
    is  => 'ro',
    isa => 'Str',
    writer => '_set_id_name',
    predicate => 'has_id_name',
);

sub has_id
{
    my $self = shift;
    my $meta = $self->meta;
    unless($self->has_id_name) {
        foreach my $attr ( $meta->get_all_attributes() ) {
            if($attr->does('AccessControl::RBAC::Meta::Attribute::Trait::PersistableAttr')
                && $attr->is_key()
               )
            {
                $self->_set_id_name($attr->name);
                return $attr->has_value($self)
            }
        }
    }
    my $id_name = $self->id_name();

    return 0 unless $id_name;

    my $attr = $meta->get_attribute($id_name);
    return $attr->has_value($self)

}

sub id
{
    my $self = shift;
    my $id_name = $self->id_name();

    return undef unless $id_name;
    my $meta = $self->meta;
    my $attr = $meta->get_attribute($id_name);
    my $reader = $attr->get_read_method;
    return $self->$reader;
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
    my @vals = ();
    foreach my $attr (@{$self->persistable_attributes()}) {
        next if(!$all && !$attr->has_value($self));
        my $reader = $attr->get_read_method;
        push @vals,
            {
                name => $attr->name,
                value => $self->$reader,
                is_key => $attr->is_key,
            };
    }
    return \@vals;
}

sub save
{
    my $self = shift;

    my $factory = AccessControl::RBAC::Factory->instance;
    return $factory->persistence_provider->save($self);

}


__PACKAGE__->meta->make_immutable;

1;
