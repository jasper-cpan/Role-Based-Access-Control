package AccessControl::RBAC::Object;

use Moose;
use MooseX::ClassAttribute;
use namespace::autoclean;

class_has 'adaptee_class' => (
    is => 'ro',
    isa => 'Str',
    # Important: you need to override the default in your subclass
    default => undef,
);

has 'adaptee' => (
    is      => 'rw',
    isa     => 'Object',
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
    my $adaptee_class = $class->adaptee_class;
    die "$class->adaptee_class is not defined " unless $adaptee_class;
    return $adaptee_class->new(@_);
}

__PACKAGE__->meta->make_immutable;

1;
