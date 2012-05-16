package AccessControl::RBAC::Object::Rose::Factory;

use Moose;
use namespace::autoclean;


# Dynamically bind interface to a object? Will it work?

our %NameToAdaptor;
our %AdaptorToName;
our %AdapteeToName;


with 'AccessControl::RBAC::Interface::Factory';

sub create
{
    my $self = shift;
    my $name = shift;
    my $class;
    if(exists $NameToAdaptor{$name} ) {
        $class = $NameToAdaptor{$name};
    }
    elsif(exists $AdaptorToName{$name}) {
        $class = $name;
    }
    else {
        die "'$name' is not supported by " . ref($name)?ref($name):$name . ".";
    }
    return $class->new(@_);
}

sub transform
{
    my $self = shift;
    my $adaptee = shift;
    my $adaptee_class = ref $adaptee;
    if(!$adaptee_class) {
        die "Object is required for transformation";
    }
    if(!exists $AdapteeToName{$adaptee_class} ) {
        die "Transformation is not supported for '$adaptee_class'.";
    }
    return $NameToAdaptor{$AdapteeToName{$adaptee_class}}->new(adaptee => $adaptee);
}

sub register_class
{
    my ($class, $adaptor_class) = @_;
    unless(eval "require $adaptor_class") {
        die "Can't load class $adaptor_class\n$@";
    }
    # TODO: check if $adaptor_class supports specified Interface

    my $attr = $adaptor_class->meta->get_attribute('adaptee');
    die "Attribute 'adaptee' is not defined." unless($attr);
    my $adaptee_class = $attr->type_constraint;
    die "The type constraint is not defined for attribute 'adaptee' of $adaptor_class." unless($adaptee_class);

    unless(eval "require $adaptee_class") {
        die "Can't load class $adaptee_class\n$@";
    }

    # TODO: check adaptee class?

    #TODO: check handlers?

    my $name = $adaptor_class->rbac_object_name();

    die "RBAC object name is not defined for class $adaptor_class" unless($name);

    $NameToAdaptor{$name} = $adaptor_class;
    $AdaptorToName{$adaptor_class} = $name;
    $AdapteeToName{$adaptee_class} = $name;
}


__PACKAGE__->meta()->make_immutable();

1;
