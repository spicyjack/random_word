#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Random::Word' );
}

diag( "Testing Random::Word $Random::Word::VERSION, Perl $], $^X" );
