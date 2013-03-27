use strict;
use warnings;

use Test::More;
use Test::Deep;

use Config::Any;

my $file = 't/example.csv';
my $cfg = Config::Any->load_files( { 
    files => [ $file ], use_ext => 1 
} );

cmp_deeply( $cfg, [{
    $file => { 
        'Älice' => {
            age  => '42',
            comment => "friend",
            mail => 'alice@example.org',
            foo => 'bar',
        },
        'Böb' => {
            age => '23',
            comment => "",
            mail => 'bob@example.org',
            foo  => "",
        }
    }
}], "read $file" );

$file = 't/args.csv';
$cfg = Config::Any->load_files( {
    files => [ $file ], 
    use_ext => 1, 
    driver_args => { 
        CSV => { 
            sep_char => ';', 
            allow_whitespace => 0,
            empty_is_undef => 1,
            with_key => 1,
        } 
    }
} );

cmp_deeply( $cfg, [{
    $file => { 
        42 => {
            id => 42,
            bar => undef,
            doz => 'Hi',
        },
        23 => {
            id => 23,
            bar => ' Hello',
            doz => undef
        },
    },
}], "read $file with driver_args" );


done_testing;
