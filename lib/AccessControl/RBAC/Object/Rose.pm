package AccessControl::RBAC::Object::Rose;

use Moose;
use namespace::autoclean;

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

    my $attr = $class->meta->get_attribute('adaptee');
    die "Attribute 'adaptee' is not defined." unless($attr);
    my $adaptee_class = $attr->type_constraint;
    die "The type constraint is not defined for attribute 'adaptee' of $class." unless($adaptee_class);
    # Get adaptee class name
    $adaptee_class = $adaptee_class->name;

    # Assumming the $adaptee_class is already loaded
    unless(eval "require $adaptee_class") {
        die "Can't load class $adaptee_class\n$@";
    }

    my $adaptee = $adaptee_class->new(@_);

    return $adaptee;
}

__PACKAGE__->meta->make_immutable;

1;
