package AccessControl::RBAC::DB::Rose::Informix::Role;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'role',

    columns =>
    [
        created_by => { type => 'integer' },
        created_on => { type => 'datetime year to second', default => 'current' },
        role_id    => { type => 'serial', not_null => 1 },
        role_name  => { type => 'varchar', length => 80, not_null => 1 },
    ],

    primary_key_columns => [ 'role_id' ],

    unique_key => [ 'role_name' ],

    allow_inline_column_values => 1,

    relationships =>
    [
        parents =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy',
            map_from  => 'child',
            map_to    => 'parent',
            type      => 'many to many',
        },

        children =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy',
            map_from  => 'parent',
            map_to    => 'child',
            type      => 'many to many',
        },

        role_permission =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::RolePermission',
            column_map => { role_id => 'role_id' },
            type       => 'one to many',
        },

        users =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::UserRoleMap',
            map_from  => 'role',
            map_to    => 'user',
            type      => 'many to many',
        },
    ],
);


1;