use strict;
use lib 'lib';
use Data::Dumper;
use AccessControl::RBAC::DB::Rose;

BEGIN {
AccessControl::RBAC::DB::Rose->register_db(
    domain   => 'main',
    type     => 'rbac_auth',
    driver   => 'Informix',
    database => 'rbac@dbhome',
    username => $ENV{DBD_INFORMIX_USERNAME},
    password => $ENV{DBD_INFORMIX_PASSWORD},
    connect_options  => { AutoCommit => 1 },
    post_connect_sql =>
    [
      'SET LOCK MODE TO WAIT 30',
      'SET ISOLATION TO DIRTY READ',
    ],
);

AccessControl::RBAC::DB::Rose->default_domain('main');
AccessControl::RBAC::DB::Rose->default_type('rbac_auth');

my $db = AccessControl::RBAC::DB::Rose->new();
my $dbh = $db->dbh();

}

use AccessControl::RBAC::DB::Rose::Informix::User;
