package AccessControl::RBAC::DB::Rose::Informix::Action;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'action',

    columns =>
    [
        action_id   => { type => 'serial', not_null => 1 },
        action_name => { type => 'varchar', length => 80, not_null => 1 },
        created_by  => { type => 'integer' },
        created_on  => { type => 'datetime year to second', default => 'current' },
    ],

    primary_key_columns => [ 'action_id' ],

    unique_key => [ 'action_name' ],

    allow_inline_column_values => 1,

    relationships =>
    [
        resource_action =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::ResourceAction',
            column_map => { action_id => 'action_id' },
            type       => 'one to many',
        },
    ],
);

1;

