package AccessControl::RBAC::DB::Rose::Informix::User;

use strict;

use base qw(AccessControl::RBAC::DB::Rose::Informix::Object);

__PACKAGE__->meta->setup
(
    table   => 'user',

    columns =>
    [
        created_by => { type => 'integer' },
        created_on => { type => 'datetime year to second', default => 'current' },
        login_name => { type => 'varchar', length => 80, not_null => 1 },
        password   => { type => 'varchar', length => 50 },
        user_id    => { type => 'serial', not_null => 1 },
    ],

    primary_key_columns => [ 'user_id' ],

    unique_key => [ 'login_name' ],

    allow_inline_column_values => 1,

    relationships =>
    [
        roles =>
        {
            map_class => 'AccessControl::RBAC::DB::Rose::Informix::UserRoleMap',
            map_from  => 'user',
            map_to    => 'role',
            type      => 'many to many',
        },
        session =>
        {
            class      => 'AccessControl::RBAC::DB::Rose::Informix::Session',
            column_map => { user_id => 'user_id' },
            type       => 'one to many',
        },
    ],
);

###############################################

sub login
{
    my ($class, $login_name, $password) = @_;
    my $user = AccessControl::RBAC::DB::Rose::Informix::User->new(login_name => $login_name);
    if($user->load(speculative => 1) && $user->password eq $password) {
        return $user;
    }
    return undef;
}


sub is_action_allowed
{
    my ($self, $resource_id, $action_id) = @_;
    my @roles = $self->roles();
    my $allowed = undef;
    foreach my $role (@roles) {
        my $allowed_in_role = $role->is_action_allowed($resource_id,$action_id);
        # deny access take precedence
        return 0 if(defined $allowed_in_role && !$allowed_in_role);
        $allowed = 1 if($allowed_in_role);
    }
    return $allowed;
}

1;

