package AccessControl::RBAC::DB::Rose::Informix::RolePermission;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'role_permission',

    columns =>
    [
        action_id   => { type => 'integer', not_null => 1 },
        created_by  => { type => 'integer' },
        created_on  => { type => 'datetime year to second', default => 'current' },
        is_allowed  => { type => 'integer', not_null => 1 },
        resource_id => { type => 'integer', not_null => 1 },
        role_id     => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'role_id', 'resource_id', 'action_id' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        resource_action =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::ResourceAction',
            key_columns =>
            {
                action_id   => 'action_id',
                resource_id => 'resource_id',
            },
        },

        role =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Role',
            key_columns => { role_id => 'role_id' },
        },
    ],
);

1;

