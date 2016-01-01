use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MySpeedDial';
use MySpeedDial::Controller::MySpeedDial;

ok( request('/')->is_success, 'Request should succeed' );
ok( request('/myspeeddial')->is_redirect, 'Request should succeed' );
done_testing();
