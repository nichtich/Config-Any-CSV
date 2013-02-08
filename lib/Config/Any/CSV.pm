package Config::Any::CSV;
#ABSTRACT: Load CSV files as config files

use strict;
use warnings;
use v5.10;

use base 'Config::Any::Base';

use Text::CSV;

sub load {
    my ($class, $file) = @_;

    my $csv = Text::CSV->new( { binary => 1, allow_whitespace => 1 } );
    my $config = { };
    open my $fh, "<", $file or die $!;

    my $names = $csv->getline($fh);
    if ( $names ) {
        my $columns = scalar @$names - 1;
        while ( my $row = $csv->getline( $fh ) ) {
            next if @$row == 1 and $row->[0] eq ''; # empty line
            $config->{ $row->[0] // "" } = {
                map { ( $names->[$_] // "" ) => $row->[$_] }
                (1..$columns)
            };
        }
    }
    die $csv->error_diag() unless $csv->eof;
    close $fh;

    return $config;
}

sub extensions {
    return ('csv');
}

1;

=head1 SYNOPSIS

The interface of Config::Any sucks, so this example uses Config::ZOMG:

    use Config::ZOMG;

    my $config = Config::ZOMG->new( 
        path => '/path/that/includes/foo.csv', # and/or foo_local.csv
        name => 'foo'
    );

=head1 DESCRIPTION

This small module adds support of CSV files to L<Config::Any>. Files with
extension C<.csv> are read with L<Text::CSV> - see that module for
documentation of the particular CSV format. Config::Any::CSV enables the option
C<binary> and C<allow_whitespace>. The first row of a CSV file is always
interpreted as a list of field names and the first field is always interpreted
as key field. For instance this CSV file

    name,age,mail
    alice, 42, alice@example.org
    bob, 23, bob@example.org

Is parsed into this Perl structure:

    {
        alice => {
            age  => '42',
            mail => 'alice@example.org'
        },
         bob => {
            age => '23',
            mail => 'bob@example.org'
        }
    }

The order of rows gets lost. If a file contains multiple rows with the same
first field value, only the last of these rows is used. Empty lines are
ignored.

=head1 SEE ALSO

L<Config::ZOMG>

=cut
