package AccessControl::RBAC::DB::Rose;

use 5.008009;
use strict;
use warnings;

use parent 'Rose::DB';

our $VERSION = '0.01';

__PACKAGE__->default_type(__PACKAGE__->init_default_type);

__PACKAGE__->default_domain(__PACKAGE__->init_default_domain);

sub init_default_type { 'rbac_auth' }

sub init_default_domain { 'main' }

1;

__END__

=head1 NAME

AccessControl::RBAC::DB::Rose - Data source registry and abstraction layer

=head1 VERSION

$Change: 220219 $

=head1 SYNOPSIS

     $db = AccessControl::RBAC::DB::Rose->new; # same as AccessControl::RBAC::DB::Rose->new('rdbc_auth');
     print 'Connected to ', $db->database, ' as user ', $db->username;
     ...

=head1 DESCRIPTION
=cut
