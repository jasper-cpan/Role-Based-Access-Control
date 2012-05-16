use strict;
use lib 'lib';
use Data::Dumper;
#use AccessControl::RBAC::User;
use GVX::DB;
GVX::DB->default_domain('development');
GVX::DB->default_type('g3admin_auth');


use AccessControl::RBAC::ObjectManager;
use AccessControl::RBAC::Object::Rose::Informix::Factory;

#my $user = AccessControl::RBAC::User->new( login_name => 'test011', password => 'pwd',);
#print Dumper($user);

#$user->save;

AccessControl::RBAC::ObjectManager->factory(AccessControl::RBAC::Object::Rose::Informix::Factory->new());

if(AccessControl::RBAC::ObjectManager->initialized) {
  print "initialzed\n";
}

#print "log name:" . AccessControl::RBAC::Object::User->logical_name . "\n";


print "create user1\n";
my $user = AccessControl::RBAC::ObjectManager->create('User',user_id => '1');
#$user->save();
#$user->load();
print Dumper($user->adaptee);


print "create user2\n";
my $user2 = AccessControl::RBAC::ObjectManager->create('User', login_name => 'user-1335896100-02');

$user2->load();

print "password: " . $user2->password() . "\n";

my $role1 = AccessControl::RBAC::ObjectManager->create('Role', role_id => 92);

$role1->load();

print "role name: " . $role1->role_name() . "\n";


my @users = $role1->get_users();
foreach my $u (@users) {
    print "  " . $u->login_name . "\n";
}

print "adding assignees\n";
$role1->add_users($user2);

print "after added:\n";
my @users = $role1->get_users();
foreach my $u (@users) {
    print "  " . $u->login_name . "(" . $u->user_id . ")\n";
}
