package AccessControl::RBAC::DB::Rose::Informix::ResourceHierarchy;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'resource_hierarchy',

    columns =>
    [
        child_resource_id  => { type => 'integer', not_null => 1 },
        parent_resource_id => { type => 'integer' },
    ],

    primary_key_columns => [ 'parent_resource_id', 'child_resource_id' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        child =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Resource',
            key_columns => { child_resource_id => 'resource_id' },
        },

        parent =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::Resource',
            key_columns => { parent_resource_id => 'resource_id' },
        },
    ],
);

1;

