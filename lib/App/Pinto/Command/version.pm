package App::Pinto::Command::version;

# ABSTRACT: show version information

use strict;
use warnings;

use Class::Load qw();

use base qw(App::Pinto::Command);

#-------------------------------------------------------------------------------

# VERSION

#-------------------------------------------------------------------------------

sub usage_desc {
    my ($self) = @_;

    my ($command) = $self->command_names();

    return "%c $command"
}

#-------------------------------------------------------------------------------

sub execute {
    my ($self, $opts, $args) = @_;

    my $app_class = ref $self->app();
    my $app_version = $self->app->VERSION();
    printf "$app_class $app_version\n";

    my $pinto_class = $self->app->pinto_class();
    Class::Load::load_class( $pinto_class );
    my $pinto_version = $pinto_class->VERSION();
    printf "$pinto_class $pinto_version\n";

    return 0;
}

#-------------------------------------------------------------------------------

=head1 DESCRIPTION

This command simply displays some version information about this application.

=cut

1;

