package AccessControl::RBAC::DB::Rose::Informix::Resource;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'resource',

    columns =>
    [
        description      => { type => 'varchar', length => 255 },
        resource_id      => { type => 'serial', not_null => 1 },
        resource_name    => { type => 'varchar', length => 80, not_null => 1 },
        resource_type_id => { type => 'integer' },
    ],

    primary_key_columns => [ 'resource_id' ],

    unique_key => [ 'resource_name' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        resource_type =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::ResourceType',
            key_columns => { resource_type_id => 'resource_type_id' },
        },
    ],

    relationships =>
    [
        resource_action =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::ResourceAction',
            column_map => { resource_id => 'resource_id' },
            type       => 'one to many',
        },

        parents =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy',
            map_from  => 'child',
            map_to    => 'parent',
            type      => 'many to many',
        },

        children =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy',
            map_from  => 'parent',
            map_to    => 'child',
            type      => 'many to many',
        },

    ],
);


######## Object Methods ##################

# add ascendants
sub add_ascendants
{
    my ($self, @ascendants) = @_;
    # TODO: check loop inheritance
    # also check the allowed inheritance constraint
    $self->add_parents(@ascendants);
    $self->save;
}

# delete ascendants
sub delete_ascendants
{
    my ($self, @ascendants) = @_;
    # TODO: fix me
    $self->delete_parents(@ascendants);
    $self->save;
}


# add descendants
sub add_descendants
{
    my ($self, @descendants) = @_;
    # TODO: check loop inheritance
    # also check the allowed inheritance constraint
    $self->add_children(@descendants);
    $self->save;
}


1;

