#!/usr/bin/env perl
use strict;
use warnings;
use MySpeedDial;

my $app = MySpeedDial->psgi_app(@_);
