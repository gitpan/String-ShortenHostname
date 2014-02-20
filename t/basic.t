#!/usr/bin/env perl

use Test::More;

my $long_domain = 'zumsel.haushaltswarenabteilung.einzelhandel.de';
my $long_host = 'verylonghostnamepartcannotbeshortend.some-domain.de';

use_ok('String::ShortenHostname');

my $sh = String::ShortenHostname->new( length => 20, keep_digits_per_domain => 3 );
isa_ok($sh, 'String::ShortenHostname');

is($sh->shorten($long_domain), 'zumsel.hau.ein.de', 'shorten 3 digits per domain' );

$sh->keep_digits_per_domain(5);
is($sh->shorten($long_domain), 'zumsel.haush.einze.de', 'shorten 5 digits per domain' );

$sh->domain_edge('~');
is($sh->shorten($long_domain), 'zumsel.haus~.einz~.de', 'shorten 5 digits per domain' );

$sh->keep_digits_per_domain(3);
is($sh->shorten($long_host), 'verylonghostnamepartcannotbeshortend.so~.de', 'shorten long domain with 3 digits per domain' );

$sh->force(1);
is($sh->shorten($long_host), 'verylonghostnamepart', 'force shortening' );

$sh->force_edge('~');
is($sh->shorten($long_host), 'verylonghostnamepar~', 'force shortening with edge string' );

done_testing();

