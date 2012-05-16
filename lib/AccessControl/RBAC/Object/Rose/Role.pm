package AccessControl::RBAC::Object::Rose::Role;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

use AccessControl::RBAC::ObjectManager;

extends 'AccessControl::RBAC::Object::Rose';

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Rose::DB::Object',
    handles => [qw/role_id role_name created_on save load/],
);

with 'AccessControl::RBAC::Interface::Role';


######## Object Methods ##################

# assign users to the role
sub add_users
{
    my ($self,@users) = @_;
    # TODO: Check user object
    my $adaptee = $self->adaptee;
    $adaptee->add_users(map { $_->adaptee } @users);
    $adaptee->save;
}

sub get_users
{
    my ($self) = @_;
    my @users = $self->adaptee->users;;
    return map { AccessControl::RBAC::ObjectManager->transform($_) } @users;
}

# add ascendants
sub add_ascendants
{
    my ($self, @ascendants) = @_;
    # TODO: check loop inheritance
    $self->add_parents(@ascendants);
    $self->save;
}

# delete ascendants
sub delete_ascendants
{
    my ($self, @ascendants) = @_;
    # TODO: fix me
    $self->delete_parents(@ascendants);
    $self->save;
}


# add descendants
sub add_descendants
{
    my ($self, @descendants) = @_;
    # TODO: check loop inheritance
    $self->add_children(@descendants);
    $self->save;
}

# resource actions
sub get_permissions
{
    my ($self,$resource_id) = @_;
    return $self->find_role_permission( $resource_id?{resource_id => $resource_id }:() );
}


sub is_action_allowed
{
    my ($self,$resource_id, $action_id) = @_;
    my ($perm) = $self->find_role_permission(
                        {
                            resource_id => $resource_id,
                            action_id => $action_id,
                        },
                    );
    my $allowed = undef;
    if($perm) {
        # deny access take precedence
        return 0 if(!$perm->is_allowed());
        $allowed = 1;
    }
    my @parents = $self->parents();
#TODO: optimize so duplicate roles won't be checked twice
    foreach my $role (@parents) {
        my $allowed_in_parent = $role->is_action_allowed($resource_id,$action_id);
        # deny access take precedence
        return 0 if(defined $allowed_in_parent && !$allowed_in_parent);
        $allowed = 1 if($allowed_in_parent);
    }
    return $allowed;
}




__PACKAGE__->meta->make_immutable;

1;
