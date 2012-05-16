package AccessControl::RBAC::Object::User;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

use Amethyst::RBAC::DB::User;

extends 'AccessControl::RBAC::Object';

#class_has '+logical_name'  => (default => 'User');
# modify me
class_has '+adaptee_class' => (default => 'Amethyst::RBAC::DB::User');

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Amethyst::RBAC::DB::User',
    handles => 'AccessControl::RBAC::Interface::User',
);

#sub build_adaptee
#{
#    my $class = shift;
#    return Amethyst::RBAC::DB::User->new(@_);
#}


with 'AccessControl::RBAC::Interface::User';

__PACKAGE__->meta->make_immutable;

1;
