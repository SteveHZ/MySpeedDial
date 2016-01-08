package MySpeedDial::Model::MySpeedDial_Model;
use Moose;
use namespace::autoclean;

use MyJSON qw (read_json write_json);

extends 'Catalyst::Model';

=head1 NAME

MySpeedDial::Model::MySpeedDial_Model - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.
MySpeedDial_Model.pm
v1.00 05/07/15 - 12/07/15
v1.10 31/12/15 - 08/01/16

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my $speed_dial;
my $json_file = 'C://Apache24/Apache24/htdocs/MySpeedDial/SpeedDial.json';

#FOR TESTING ONLY :
#my $json_file = '../root/static/json/SpeedDial.json';
#my $json_file = 'myspeeddial/root/static/json/SpeedDial.json';

sub get_data {
	return $speed_dial = read_json ($json_file);
}

sub get_website {
	my ($self, $heading, $search) = @_;
	my $array = \@{ $speed_dial->{data}->{$heading} };

	for my $site (@$array) {
		return $site->{website} if $site->{name} eq $search;
    }
}

sub edit_site {
	my ($self, $params) = @_;
	my $search = $params->{'item'};
    my (@headings) = @{ $speed_dial->{headings} };

    for (@headings) {
        my $array = \@{ $speed_dial->{data}->{$_} };
        for my $site (@$array) {
			$site->{website} = $params->{website} if $site->{name} eq $search;
        }
    }

	write_json ($json_file, $speed_dial);
}

sub add_new {
	my ($self, $heading, $params) = @_;

	my $site = {
		"name" => $params->{'item'},
		"website" => $params->{'website'},
	};
	
	my $array = \@{ $speed_dial->{data}->{$heading} };
	push (@$array, $site);
    
	write_json ($json_file, $speed_dial);
}

sub remove {
	my ($self, $heading, $search) = @_;
	my $array = \@{ $speed_dial->{data}->{$heading} };
	my $count = 0;
	
    LOOP:
	for my $site (@$array) {
		if ($site->{name} eq $search) {
			splice (@$array, $count, 1);
			last LOOP;
		}
		$count++;
    }
	
	write_json ($json_file, $speed_dial);
}

sub add_new_heading {
	my ($self, $name) = @_;
	
	push ( @{ $speed_dial->{headings} }, $name);
	$speed_dial->{data}->{$name} = ();

	write_json ($json_file, $speed_dial);
}	
# 	to remove key from hash for remove_heading, use either undef or delete

__PACKAGE__->meta->make_immutable;

1;
