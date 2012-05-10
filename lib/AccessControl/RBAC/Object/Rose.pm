package AccessControl::RBAC::Object::Rose;


use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

has 'adaptee' => (
    is      => 'rw',
);


around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    my %args;

    if(@_ == 1 && ref $_[0] eq 'HASH') {
        %args = %{$_[0]};
    }
    else {
        %args =  @_ ;
    }
    if(!exists $args{adaptee}) {
        $args{adaptee} = $class->build_adaptee(@_);
    }

    return $class->$orig(%args);
};



sub build_adaptee
{
    my $class = shift;
    die "The $class->build_adaptee is not implemented";
}

__PACKAGE__->meta->make_immutable;

1;
