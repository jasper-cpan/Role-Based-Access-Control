package AccessControl::RBAC::DB::Rose::Informix::RoleHierarchy;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'role_hierarchy',

    columns =>
    [
        child_role_id  => { type => 'integer', not_null => 1 },
        created_by     => { type => 'integer' },
        created_on     => { type => 'datetime year to second', default => 'current', not_null => 1 },
        parent_role_id => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'parent_role_id', 'child_role_id' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        child =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Role',
            key_columns => { child_role_id => 'role_id' },
        },

        parent =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Role',
            key_columns => { parent_role_id => 'role_id' },
        },
    ],
);

1;

