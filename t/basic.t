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
            mail => 'alice@example.org'
        },
        'Böb' => {
            age => '23',
            mail => 'bob@example.org'
        }
    }
}], "read $file" );

done_testing;
