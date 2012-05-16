package AccessControl::RBAC::DB::Rose::Informix::ResourceType;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'resource_type',

    columns =>
    [
        description        => { type => 'varchar', length => 255 },
        resource_type_id   => { type => 'serial', not_null => 1 },
        resource_type_name => { type => 'varchar', length => 80, not_null => 1 },
    ],

    primary_key_columns => [ 'resource_type_id' ],

    unique_key => [ 'resource_type_name' ],

    allow_inline_column_values => 1,

    relationships =>
    [
        allowed_resource_inheritance =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance',
            column_map => { resource_type_id => 'parent_resource_type' },
            type       => 'one to many',
        },

        allowed_resource_inheritance_objs =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance',
            column_map => { resource_type_id => 'child_resource_type' },
            type       => 'one to many',
        },

        resource =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::Resource',
            column_map => { resource_type_id => 'resource_type_id' },
            type       => 'one to many',
        },
    ],
);

1;

