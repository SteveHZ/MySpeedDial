use strict;
use warnings;
use Test::More;


use Catalyst::Test 'MySpeedDial';
use MySpeedDial::Controller::MySpeedDial;

ok( request('/myspeeddial')->is_success, 'Request should succeed' );
done_testing();
