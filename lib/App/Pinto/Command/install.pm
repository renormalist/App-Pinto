# ABSTRACT: install stuff from the repository

package App::Pinto::Command::install;

use strict;
use warnings;

#-----------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#------------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'cpanm-exe|cpanm=s'       => 'Path to the cpanm executable'                 ],
        [ 'cpanm-options|o:s%'      => 'name=value pairs of cpanm options'            ],
        [ 'local-lib|l=s'           => 'install into a local lib directory'           ],
        [ 'local-lib-contained|L=s' => 'install into a contained local lib directory' ],
        [ 'pull'                    => 'pull missing prereqs onto the stack first'    ],
        [ 'stack|s=s'               => 'Use the index for this stack'                 ],

    );
}

#------------------------------------------------------------------------------

sub validate_args {
    my ($self, $opts, $args) = @_;

    my $local_lib = delete $opts->{local_lib};
    $opts->{cpanm_options}->{'local-lib'} = $local_lib
        if $local_lib;

    my $local_lib_contained = delete $opts->{local_lib_contained};
    $opts->{cpanm_options}->{'local-lib-contained'} = $local_lib_contained
        if $local_lib_contained;

    return 1;
}

#------------------------------------------------------------------------------

sub args_attribute { return 'targets' }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1 }

#------------------------------------------------------------------------------
1;

__END__

=pod

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT install [OPTIONS] TARGET...
  pinto --root=REPOSITORY_ROOT install [OPTIONS] < LIST_OF_TARGETS

=head1 DESCRIPTION

!! THIS COMMAND IS EXPERIMENTAL !!

Installs packages from the repository into your environment.  This
is just a thin wrapper around L<cpanm> that is wired to fetch
everything from the Pinto repository, rather than a public CPAN
mirror.

If the C<--pull> option is given, all prerequisites
(including the targets themselves) will be pulled onto the stack
before attempting to install them.  If any prerequisite cannot be
pulled because it does not exist or blocked by a pin, then the
installation will not proceed.

=head1 COMMAND ARGUMENTS

Arguments are the things you want to install.  These can be package
names, distribution paths, URLs, local files, or directories.  Look at
the L<cpanm> documentation to see all the different ways of specifying
what to install.

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --cpanm-exe PATH

=item --cpanm PATH

Sets the path to the L<cpanm> executable.  If not specified, the
C<PATH> will be searched for the executable.  At present, cpanm
version 1.500 or newer is required.

=item --cpanm-options NAME=VALUE

=item -o NAME=VALUE

These are options that you wish to pass to L<cpanm>.  Do not prefix
the option name with a '-'.  You can pass any option you like, but the
C<--mirror> and C<--mirror-only> options will always be set to point
to the Pinto repository.

=item --local-lib DIRECTORY

=item -l DIRECTORY

Shortcut for setting the C<--local-lib> option on L<cpanm>.  Same as
C<--cpanm-options local-lib=DIRECTORY> or C<-o l=DIRECTORY>.

=item --local-lib-contained DIRECTORY

=item -L DIRECTORY

Shortcut for setting the C<--local-lib-contained> option on L<cpanm>.
Same as C<--cpanm-options local-lib-containted=DIRECTORY> or C<-o
L=DIRECTORY>.

=item --pull

Recursively Pull prerequsiste packages (or the targets themselves)
onto the stack before installing.  Without the C<--pull> option, all
prerequisites must already be on the stack.  See the
L<pull|App::Pinto::Command::pull> command to explicitly pull packages
onto a stack or the L<merge|App::Pinto::Command::merge> command to
merge packages from one stack to another.

=item --stack=NAME

=item -s NAME

Use the stack with the given NAME as the repository index.  When
used with the C<--pull> option, this also determines which stack
prerequisites will be pulled onto. Defaults to the name of whichever
stack is currently marked as the default stack.  Use the
L<stacks|App::Pinto::Command::stacks> command to see the stacks in
the repository.

=back

=cut
