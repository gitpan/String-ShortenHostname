#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use IPC::Run;

my ( $out, $err );

IPC::Run::run(
	[ 'bin/shorten_hostname', '-l', '20' ],
	'<', 't/test_data',
	'>', \$out,
	'2>', \$err );

is($?, 0, 'positive return code');

is($err, '', 'empty error output');

is( $out, 'falcon.lon~n.lon~n~>
r2d2.lon~n.sho~n.c~>
c3po.sub.sho~n.cc.~>
r4p17.sub.sho~n.bl~>
', 'correct output');

done_testing();

