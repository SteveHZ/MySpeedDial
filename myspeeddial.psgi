use strict;
use warnings;

use MySpeedDial;

my $app = MySpeedDial->apply_default_middlewares(MySpeedDial->psgi_app);
$app;

