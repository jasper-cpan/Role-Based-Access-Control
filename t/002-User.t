# -*- perl -*-

use Test::More tests => 7;

BEGIN { use_ok( 'AccessControl::RBAC::User' ); }

BEGIN { use_ok( 'AccessControl::RBAC::Role' ); }

BEGIN { use_ok( 'AccessControl::RBAC::Resource' ); }

BEGIN { use_ok( 'AccessControl::RBAC::Operation' ); }

BEGIN { use_ok( 'AccessControl::RBAC::Permission' ); }

BEGIN { use_ok( 'AccessControl::RBAC::RolePermission' ); }


my $user1 = AccessControl::RBAC::User->new(
                login_name => 'user01',
                password => 'user01_pwd',
                dummy => 1,
            );
isa_ok ($user1, 'AccessControl::RBAC::User');


my $user2 = AccessControl::RBAC::User->new(
                login_name => 'user02',
                password => 'user02_pwd',
                dummy => 2,
            );


$user1->save();
$user2->save();


# Create Role 1
my $role1 = AccessControl::RBAC::Role->new(
                role_name => 'role01',
            );

$role1->save();

my $role2 = AccessControl::RBAC::Role->new(
                role_name => 'role02',
            );

$role2->save();


my $persister = AccessControl::RBAC::Persistence::Factory->persister;

$persister->assign_user($user1,$role1);

$persister->assign_user($user2,$role2);

my $res1 = AccessControl::RBAC::Resource->new(
                resource_name => 'resource01',
            );


$persister->save_resource($res1);


my $opr_read = AccessControl::RBAC::Operation->new(
                operation_name => 'read',
            );


$persister->save_operation($opr_read);


my $opr_write = AccessControl::RBAC::Operation->new(
                operation_name => 'write',
            );


$persister->save_operation($opr_write);



my $perm1 = AccessControl::RBAC::Permission->new(
                permission_name => 'permission01',
                resource_id => $res1->resource_id,
                operation_id => $opr_read->operation_id,
            );


$persister->save_permission($perm1);

my $perm2 = AccessControl::RBAC::Permission->new(
                permission_name => 'permission02',
                resource_id => $res1->resource_id,
                operation_id => $opr_write->operation_id,
            );


$persister->save_permission($perm2);


my $role_perm1 = AccessControl::RBAC::RolePermission->new(
                    role_id => $role1->role_id,
                    permission_id => $perm1->permission_id,
                 );


$persister->save_role_permission($role_perm1);


my $role_perm2 = AccessControl::RBAC::RolePermission->new(
                    role_id => $role2->role_id,
                    permission_id => $perm2->permission_id,
                 );

$persister->save_role_permission($role_perm2);


use Data::Dumper;
print STDERR "role_permission_mapping: " .  Dumper($persister->role_permission_mapping);



my $user = $persister->login_user('user01','user01_pwd');

my $session = $persister->create_session();

$persister->authorize_user_session($user,$session);


use Data::Dumper;
print STDERR Dumper($session);


if($persister->check_access($session,$res1,$opr_read)) {
    print STDERR "user 1 can read\n";
}
else {
    die "TODO";
}

if($persister->check_access($session,$res1,$opr_write)) {
    die "user 1 has wrong perm";
}
else {
    print STDERR "user 1 can NOT write\n";
}