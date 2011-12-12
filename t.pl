use lib lib;
use Data::Dumper;
use AccessControl::RBAC::User;
use AccessControl::RBAC::UserTest;
use AccessControl::RBAC::Role;
#use AccessControl::RBAC::Persistence::Cache;
use AccessControl::RBAC::Resource;
#use AccessControl::RBAC::Operation;
#use AccessControl::RBAC::Permission;
#use AccessControl::RBAC::RolePermission;

#print "user test physical name: ", AccessControl::RBAC::UserTest->physical_name(),"\n";


#print "user physical name: ", AccessControl::RBAC::User->physical_name(),"\n";
#{
#    local $Data::Dumper::Maxdepth = 2;
#    print Dumper(AccessControl::RBAC::UserTest->persistable_attrs);
#}



my $user1 = AccessControl::RBAC::User->new(
              login_name => 'user01',
              password => 'user01_pwd',
              dummy => 1,
);

my $user2 = AccessControl::RBAC::User->new(
              login_name => 'user02',
              password => 'user02_mod_pwd',
              dummy => 1,
);

$user1->persist();
$user2->persist();




my $role1 = AccessControl::RBAC::Role->new(
              role_name => 'role01',
);

my $role2 = AccessControl::RBAC::Role->new(
              role_name => 'role02',
);

$role1->persist();
$role2->persist();

$user1->assign_role($role1);

print "resource\n";

my $res1 = AccessControl::RBAC::Resource->new(
                resource_name => 'resource01',
            );

$res1->persist();

#
#my $opr_read = AccessControl::RBAC::Operation->new(
#                operation_name => 'read',
#            );
#
#$opr_read->persist();
#
#
#my $opr_write = AccessControl::RBAC::Operation->new(
#                operation_name => 'write',
#            );
#
#
#$opr_write->persist();
#
#
#my $perm1 = AccessControl::RBAC::Permission->new(
#                permission_name => 'permission01',
#                resource_id => $res1->resource_id,
#                operation_id => $opr_read->operation_id,
#            );
#
#
#$perm1->persist();
#
#my $perm2 = AccessControl::RBAC::Permission->new(
#                permission_name => 'permission02',
#                resource_id => $res1->resource_id,
#                operation_id => $opr_write->operation_id,
#            );
#
#
#$perm2->persist();
#
#
#my $role_perm1 = AccessControl::RBAC::RolePermission->new(
#                    role_id => $role1->role_id,
#                    permission_id => $perm1->permission_id,
#                 );
#
#
#$role_perm1->persist();
#
#
#my $role_perm2 = AccessControl::RBAC::RolePermission->new(
#                    role_id => $role2->role_id,
#                    permission_id => $perm2->permission_id,
#                 );
#
#$role_perm2->persist();
#
#
#
#
my $p = AccessControl::RBAC::PersistenceFactory->instance->current_provider();
#
#my $u = $p->find('AccessControl::RBAC::User','11');
#
#print Dumper($u);
#
my @users = $p->lookup('user', { login_name => qr/^User/i });

print Dumper(\@users);
#
#
#
#
#
#if(0) {
#
#    my $cache =  AccessControl::RBAC::Persistence::Cache->new();
#
#    $cache->set_cache_switch($user1->physical_name,1);
#
#    $cache->set($user1);
#    $cache->set($user2);
#
#    #print Dumper($cache);
#
#
#
#    my $user = $cache->get($user1->physical_name,'22');
#
#    print Dumper($user);
#
#    print Dumper([$cache->lookup($user1->physical_name,password=> 'user012_pwd') ]);
#
#}
#
#
#
##print Dumper(AccessControl::RBAC::User->meta);
#
#
#
