package AccessControl::RBAC::DB::Rose::Informix::AllowedResourceInheritance;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'allowed_resource_inheritance',

    columns =>
    [
        child_resource_type  => { type => 'integer', not_null => 1 },
        is_perm_inheritable  => { type => 'integer', not_null => 1 },
        parent_resource_type => { type => 'integer', not_null => 1 },
    ],

    primary_key_columns => [ 'parent_resource_type', 'child_resource_type' ],

    allow_inline_column_values => 1,

    foreign_keys =>
    [
        resource_type =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::ResourceType',
            key_columns => { parent_resource_type => 'resource_type_id' },
        },

        resource_type_obj =>
        {
            class       => 'AccessControl::RBAC::DB::Rose::Informix::ResourceType',
            key_columns => { child_resource_type => 'resource_type_id' },
        },
    ],
);

1;

