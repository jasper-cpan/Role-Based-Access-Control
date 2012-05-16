package AccessControl::RBAC::DB::Rose::Informix::UserRoleMap;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'user_role_map',

    columns =>
    [
        created_by => { type => 'integer' },
        created_on => { type => 'datetime year to second', default => 'current' },
        role_id    => { type => 'integer', not_null => 1 },
        user_id    => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'user_id', 'role_id' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        role =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Role',
            key_columns => { role_id => 'role_id' },
        },

        user =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::User',
            key_columns => { user_id => 'user_id' },
        },
    ],
);

1;

