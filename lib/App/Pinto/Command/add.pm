package App::Pinto::Command::add;

# ABSTRACT: add local archives to the repository

use strict;
use warnings;

#------------------------------------------------------------------------------

use base 'App::Pinto::Command';

#------------------------------------------------------------------------------

# VERSION

#-----------------------------------------------------------------------------

sub opt_spec {
    my ($self, $app) = @_;

    return (
        [ 'author=s'    => 'Your (alphanumeric) author ID'     ],
        [ 'dryrun'      => 'Do not commit any changes'         ],
        [ 'force'       => 'Overwrite existing archive'        ],
        [ 'norecurse'   => 'Do not recursively import prereqs' ],
        [ 'pin'         => 'Pin packages to the stack'         ],
        [ 'stack|s=s'   => 'Put packages into this stack'      ],
    );
}

#------------------------------------------------------------------------------

sub args_attribute { return 'archives' }

#------------------------------------------------------------------------------

sub args_from_stdin { return 1 }

#------------------------------------------------------------------------------

1;

__END__

=head1 SYNOPSIS

  pinto --root=REPOSITORY_ROOT add [OPTIONS] ARCHIVE_FILE ...
  pinto --root=REPOSITORY_ROOT add [OPTIONS] < LIST_OF_ARCHIVE_FILES

=head1 DESCRIPTION

This command adds local distribution archives to the repository.
Then it recursively pulls all the distributions that are necessary
to satisfy their prerequisites.

When locating packages, Pinto first looks at the the packages that
already exist in the local repository, then Pinto looks at the
packages that are available on the upstream repositories.

=head1 COMMAND ARGUMENTS

Arguments to this command are paths to the distribution archives that
you wish to add.  Each of these files must exist and must be readable.

You can also pipe arguments to this command over STDIN.  In that case,
blank lines and lines that look like comments (i.e. starting with "#"
or ';') will be ignored.

=head1 COMMAND OPTIONS

=over 4

=item --author NAME

Set the identity of the distribution author.  The C<NAME> must be
alphanumeric characters (no spaces) and will be forced to uppercase.
Defaults to the C<user> specified in your C<~/.pause> configuration
file (if such file exists).  Otherwise, defaults to your current login
username.

=item --dryrun

Go through all the motions, but do not actually commit any changes to
the repository.  Use this option to see how operations would
potentially impact the stack.


=item --norecurse

Do not recursively pull distributions required to satisfy the
prerequisites of the added distributions.

=item --pin

Pins all the packages in the added distributions to the stack, so they
cannot be changed until you unpin them.  The pin does not apply to any
prerequisites that are pulled in for this distribution.  However, you
may pin them separately with the
L<pin|App::Pinto::Command::pin> command, if you so desire.

=item --stack NAME

Puts all the packages onto the stack with the given NAME.  Defaults
to the name of whichever stack is currently marked as the default
stack.  Use the L<stacks|App::Pinto::Command::stacks> command
to see the stacks in the repository.

=item --force

Usually if the package already exists (e.g., because it has the same
version number) you cannot add it twice. With this option you can.

It drops the existing archive file from the repository and adds the
new one back again. It registers it for the original stacks, restores
the original pinning, and it recursively pulls all the prerequisites
(unless C<--norecurse> is set), for each of the original stacks.

With this option you can hotfix a repository or use your repository as
an experimental staging area before you upload to CPAN - without
inflating version numbers. Only use it when you know what you are
doing.

=back

=cut
