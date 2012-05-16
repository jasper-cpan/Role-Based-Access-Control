package AccessControl::RBAC::DB::Rose::Informix::Session;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'session',

    columns =>
    [
        created_on       => { type => 'datetime year to second', default => 'current' },
        last_accessed_on => { type => 'datetime year to second' },
        session_id       => { type => 'bigserial', not_null => 1 },
        session_key      => { type => 'varchar', length => 80, not_null => 1 },
        status           => { type => 'character', default => 'A', length => 1, not_null => 1 },
        user_id          => { type => 'integer' },
    ],

    primary_key_columns => [ 'session_id' ],

    unique_key => [ 'session_key' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        user =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::User',
            key_columns => { user_id => 'user_id' },
        },
    ],
);

1;

