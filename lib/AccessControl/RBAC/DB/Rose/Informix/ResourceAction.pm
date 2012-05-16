package AccessControl::RBAC::DB::Rose::Informix::ResourceAction;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'resource_action',

    columns =>
    [
        action_id            => { type => 'integer', not_null => 1 },
        created_by           => { type => 'integer' },
        created_on           => { type => 'datetime year to second', default => 'current' },
        description          => { type => 'varchar', length => 255 },
        resource_action_name => { type => 'varchar', length => 80, not_null => 1 },
        resource_id          => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'resource_id', 'action_id' ],

    unique_key => [ 'resource_action_name' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        action =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Action',
            key_columns => { action_id => 'action_id' },
        },

        resource =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Resource',
            key_columns => { resource_id => 'resource_id' },
        },
    ],

    relationships =>
    [
        role_permission =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::RolePermission',
            column_map => { action_id   => 'action_id', resource_id => 'resource_id' },
            type       => 'one to many',
        },
    ],
);

1;

