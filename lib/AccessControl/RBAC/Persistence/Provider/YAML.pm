package AccessControl::RBAC::Persistence::Provider::YAML;

use Moose;
use namespace::autoclean;

use List::Util qw();
use YAML::Syck;
use Try::Tiny;

use Data::Dumper;

extends 'AccessControl::RBAC::Persistence::Provider';

with 'AccessControl::RBAC::Persistence::Role::PersistenceProvider';

has 'cache' => (
    is        => 'ro',
    isa       => 'HashRef',
    default   => sub { {} },
);


sub get_name_by_class
{
    my ($self,$object) = @_;
    my $class_name = blessed $object;
    if(!$class_name) {
        if(!$object || ref $object) {
            die "Invalid class name";
        }
        $class_name = $object;
    }

    my $data = $self->registry->{by_class_name}{$class_name};
    if(!$data || !exists $data->{logical_name}) {
        die "Logical name is not defined for class '$class_name'";
    }
    return ($data->{logical_name},$data->{physical_name}) if wantarray;
    return $data->{logical_name};
}


sub persist
{
    my ($self,$object) = @_;
    my $logical_name = $self->get_name_by_class($object);
    $self->load_file($logical_name);
    unless($object->primary_key_has_value) {
        die "Auto increament doesn't support for composite key." if($object->is_composite_primary_key());
        my ($key_name) = $object->primary_key();
        my $value = $self->_get_max_value($logical_name,$key_name);
        $object->primary_key_value(defined $value?$value+1:1);
    }
    $self->add_to_cache($logical_name,[$object->primary_key()],$object->persistable_attribute_values());
    $self->save_file($logical_name);
}

sub find
{
    my ($self,$logical_name,$primary_key) = @_;

    #TODO: do some check here
    my $class = $self->registry->{by_logical_name}{$logical_name}{class};


    $self->load_file($logical_name);
    my @pks = $class->primary_key();
    if(@pks > 1 && ref $primary_key ne 'HASH') {
        die "$class contains composite primary key. Please provide a HASHREF as parameter.";
    }
    elsif(@pks == 1) {
        $primary_key = { $pks[0] => "$primary_key" };
    }
    else {
        die "Invalid parameter";
    }
    my $data = $self->cache->{$logical_name};

    foreach my $key (@pks) {
        die "Key $key is not provided" unless(exists $primary_key->{$key});
        if(!$data || ref $data ne 'HASH') {
            return undef;
        }
        my $key_val = $primary_key->{$key};
        return undef unless(exists $data->{$key_val});
        $data = $data->{$key_val};
    }
    return $class->new($data);

}

sub lookup
{
    my ($self,$logical_name,$conds) = @_;

    #TODO: do some check here
    my $class = $self->registry->{by_logical_name}{$logical_name}{class};



    $self->load_file($logical_name);
    my $data = $self->cache->{$logical_name};
    my @matched = ();
    $self->lookup_hash($data,$conds,\@matched);
    if(@matched) {
        return map { $class->new($_) } @matched;
    }
    return undef;
}


sub add_to_cache
{
    my ($self,$namespace,$key,$data) = @_;

print Dumper([$namespace,$key,$data]);
    my @pks = $key;
    if(ref $key eq 'ARRAY') {
        @pks = @$key;
    }
    elsif(ref $key) {
        die "Invalid parameter type";
    }

    my $cache = $self->cache;
    $cache->{$namespace} ||= {};
    my $storage = $cache->{$namespace};

    my $last_key = pop @pks;
    foreach my $key (@pks) {
        my $val = $data->{$key};
        $storage->{$val} ||= {};
        $storage = $storage->{$val};
    }
    $storage->{$data->{$last_key}} = $data;
}

sub load_file
{
    my ($self,$logical_name) = @_;

    my $physical_name = $self->registry->{by_logical_name}{$logical_name}{physical_name};

    #TODO: add real path
    my $filename = "$physical_name.yaml";
    my $data = {};
    if(-r $filename) {
        $data = LoadFile($filename);
        die "Incompatible file format ($filename)" if(ref $data ne 'HASH');
        $self->cache->{$logical_name} = $data;
    }
    else {
        $self->cache->{$logical_name} = {};
    }
    return;
}

sub lookup_hash
{
    # we expect $out is a array ref
    my ($self,$hash,$conds,$out) = @_;

    my $compare = 1;
    foreach my $key (keys %$hash) {
        if(ref $hash->{$key} eq 'HASH') {
            $compare = 0;
            $self->lookup_hash($hash->{$key},$conds,$out);
        }
    }
    if($compare) {
        my $match = 1;
        foreach my $attr_name (keys %$conds) {
            if(!exists $hash->{$attr_name}) {
                $match = 0;
                last;
            }
            my $cond = $conds->{$attr_name};
            if(ref $cond eq 'Regexp') {
                $match = $hash->{$attr_name} =~ /$cond/;
            }
            else {
                $match = $hash->{$attr_name} eq $cond;
            }
            last unless $match;
        }
        push @$out,$hash if($match);
    }
}


sub save_file
{
    my ($self,$logical_name) = @_;

    my $physical_name = $self->registry->{by_logical_name}{$logical_name}{physical_name};

    #TODO: add real path
    my $filename = "$physical_name.yaml";

    DumpFile($filename,$self->cache->{$logical_name});
    return;
}


#TODO: be more generic?
sub _get_max_value
{
    my ($self,$namespace, $column) = @_;
    my $data = $self->cache->{$namespace};
    my $max = undef;
    foreach my $val (values %$data) {
        next unless (ref $val eq 'HASH');
        if(defined $val->{$column} ) {
            if(defined $max) {
                $max = $val->{$column} if($val->{$column}> $max);
            }
            else {
                $max = $val->{$column};
            }
        }
    }
    return $max;
}





# cache users in memeory
has 'users' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Object]',
    default   => sub { {} },
    handles   => {
        set_user     => 'set',
        get_user     => 'get',
        has_no_user  => 'is_empty',
    },

  );

# cache roles in memeory
has 'roles' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Object]',
    default   => sub { {} },
    handles   => {
        set_role     => 'set',
        get_role     => 'get',
        has_no_role  => 'is_empty',
    },
  );


# cache resources in memeory
has 'resources' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Object]',
    default   => sub { {} },
    handles   => {
        set_resource     => 'set',
        get_resource     => 'get',
        has_no_resource  => 'is_empty',
    },
  );


# cache operation in memeory
has 'operations' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Object]',
    default   => sub { {} },
    handles   => {
        set_operation     => 'set',
        get_operation     => 'get',
        has_no_operation  => 'is_empty',
    },
  );

# cache resource permission in memeory
has 'permissions' => (
    traits    => ['Hash'],
    is        => 'ro',
    isa       => 'HashRef[Object]',
    default   => sub { {} },
    handles   => {
        set_permission     => 'set',
        get_permission     => 'get',
        has_no_permission  => 'is_empty',
    },
  );


# User to Role mapping
has 'user_role_mapping' => (
    is        => 'ro',
    isa       => 'HashRef[ArrayRef[Object]]',
    default   => sub { {} },
  );

# Role to User mapping
has 'role_user_mapping' => (
    is        => 'ro',
    isa       => 'HashRef[ArrayRef[Object]]',
    default   => sub { {} },
  );


# Role to Permission mapping
has 'role_permission_mapping' => (
    is        => 'ro',
    isa       => 'HashRef[ArrayRef[Object]]',
    default   => sub { {} },
  );


sub save_user
{
    my ($self,$user) = @_;

    if(!$user->user_id()) {
        # Generate a primary key
        my $max_id = List::Util::max(keys %{$self->users}) || 0;
        $user->user_id($max_id +1);
    }
    $self->set_user($user->user_id => $user);

print STDERR Dumper($self->users);

    1;
}

sub delete_user
{
}


sub save_role
{
    my ($self,$role) = @_;
    if(!$role->role_id()) {
        my $max_id = List::Util::max(keys %{$self->roles}) || 0;
        $role->role_id($max_id +1);
    }
    $self->set_role($role->role_id => $role);

print STDERR Dumper($self->roles);

    1;
}

sub save_resource
{
    my ($self,$resource) = @_;
    if(!$resource->resource_id()) {
        my $max_id = List::Util::max(keys %{$self->resources}) || 0;
        $resource->resource_id($max_id +1);
    }
    $self->set_resource($resource->resource_id => $resource);

print STDERR Dumper($self->resources);

    1;
}


sub save_operation
{
    my ($self,$operation) = @_;
    if(!$operation->operation_id()) {
        my $max_id = List::Util::max(keys %{$self->operations}) || 0;
        $operation->operation_id($max_id +1);
    }
    $self->set_operation($operation->operation_id => $operation);

print STDERR Dumper($self->operations);

    1;
}

sub save_permission
{
    my ($self,$permission) = @_;
    if(!$permission->permission_id()) {
        my $max_id = List::Util::max(keys %{$self->permissions}) || 0;
        $permission->permission_id($max_id +1);
    }
    my $resource_id = $permission->resource_id;

    $self->set_permission($permission->permission_id => $permission);

print STDERR Dumper(['permissions',$self->permissions]);

    1;
}


sub delete_role
{
}

# This command assigns a user to a role
sub assign_user
{
    my ($self,$user,$role) = @_;
    my $user_roles = $self->user_role_mapping;
    my $roles = $user_roles->{$user->user_id} || [];
    #TODO: check if the role already assigned
    push @$roles, $role;
    $user_roles->{$user->user_id} = $roles;

    my $role_users = $self->role_user_mapping;
    my $users = $role_users->{$role->role_id} || [];
    push @$users, $user;
    $role_users->{$role->role_id} = $users;

print STDERR Dumper([$self->user_role_mapping, $self->role_user_mapping]);

}

# Save RolePermission and add to hash role_permission_mapping
sub save_role_permission
{
    my ($self,$role_perm) = @_;
    my $role_perm_mapping = $self->role_permission_mapping;
    my $role_perms = $role_perm_mapping->{$role_perm->role_id} || [];
    push @$role_perms, $role_perm;
    $role_perm_mapping->{$role_perm->role_id} = $role_perms;
}

sub deassign_user
{
}

sub grant_permission
{
}

sub revoke_permission
{
}


sub lookup__
{
    my ($self,$objects,%conds) = @_;
    #TODO: check parameters (objects should be array ref, etc)
    my @found;
    foreach my $obj (@$objects) {

        my $match = undef;
        #TODO: move the loop outside?
        foreach my $attr_name (%conds) {

            next unless($obj->can($attr_name));
            $match = 1 unless(defined $match);
            # TODO: case sensive or non-sensitive?
            # TODO: potentially unsafe if the attr_name collides with a regular method
            if($obj->$attr_name ne $conds{$attr_name}) {
                $match = 0;
                last;
            }
        }
        push @found,$obj if($match);
    }
    return undef unless (@found);
    return \@found;
}

sub lookup_user
{
    my ($self,%conds) = @_;
    #TODO: check parameters


    return $self->lookup([values %{$self->users}],%conds);
}

sub lookup_permission
{

    my ($self,%conds) = @_;
    #TODO: check parameters


    return $self->lookup([values %{$self->permissions}],%conds);

}

sub login_user
{
    my ($self,$login_name,$password) = @_;
    my ($users) = $self->lookup_user(login_name => $login_name);
    return undef if(!$users);
    print STDERR Dumper($users);

    die "Multiple user found" if(@$users>1);
    my $user = $users->[0];

    # Compare hash
    return undef if($user->password ne $password);
    return $user;

}

sub create_session
{
    my ($self) = @_;
    my $session = AccessControl::RBAC::Session->new(
        session_id => int(rand(10000)),
        session_token => 'TOKEN.' . sprintf('%05d',int(rand(99999))),
    );
    return $session;
}

sub authorize_user_session
{
    my ($self,$user,$session) = @_;
    $session->user($user);
    $session;
}

sub user_roles
{
    my ($self,$user) = @_;
    my $user2role = $self->user_role_mapping();
    my $user_id = $user->user_id();
    if(exists $user2role->{$user_id}) {
        return $user2role->{$user_id};
    }
    return undef;
}

sub check_access
{
    my ($self,$session,$resource,$operation) = @_;
    my $roles = $self->user_roles($session->user);

print STDERR "lookup roles: " . Dumper($roles);

    return 0 unless $roles;

    my $perms = $self->lookup_permission(resource_id => $resource->resource_id, operation_id => $operation->operation_id);

    return 0 if(@$perms < 1);

    my $permission = $perms->[0];

print STDERR "lookup permisson: " . Dumper($permission);

    my $role_perm_mapping = $self->role_permission_mapping;

    foreach my $role (@$roles) {
        if(exists $role_perm_mapping->{$role->role_id}) {
            my $role_perms = $role_perm_mapping->{$role->role_id};
            if($self->lookup($role_perms, permission_id=> $permission->permission_id)) {
                # TODO: check negative permissions
                return 1;
            }
        }
    }
    return 0;
}

__PACKAGE__->meta->make_immutable;

1;
