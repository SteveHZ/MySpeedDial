package MySpeedDial::Model::MySpeedDial_Model;
use Moose;
use namespace::autoclean;

use JSON;

extends 'Catalyst::Model';

=head1 NAME

MySpeedDial::Model::MySpeedDial_Model - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.
MySpeedDial_Model.pm
v1.00 05/07/15 - 12/07/15
v1.10 31/12/15 - 01/01/16

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my $speed_dial;
my $json_file = 'root/static/json/SpeedDial.json';


sub read_json {
    local $/; # end of record character

    open (my $fh,'<', $json_file) or die "\n\n Can't open file !!!";
    my $json_text = <$fh>;
    close $fh;

	$speed_dial = decode_json ($json_text);
	return $speed_dial;
}

sub write_json {
    my ($self, $data) = @_;

    my $json = JSON->new;
    my $pretty_print = $json->pretty->encode( $speed_dial );

    open (my $fh,'>', $json_file);
    print $fh $pretty_print;
    close $fh;
}

sub get_website {
	my ($self, $search) = @_;
    my (@headings) = @{ $speed_dial->{headings} };

    for (@headings) {
        my @array = @{ $speed_dial->{data}->{$_} };
        for my $site (@array) {
			return $site->{website} if $site->{name} eq $search;
        }
    }
}

sub edit_site {
	my ($self, $params) = @_;
	my $search = $params->{'item'};
    my (@headings) = @{ $speed_dial->{headings} };

    for (@headings) {
        my @array = @{ $speed_dial->{data}->{$_} };
        for my $site (@array) {
			$site->{website} = $params->{'website'} if $site->{name} eq $search;
        }
    }

	write_json ($speed_dial);
}

sub add_new {
	my ($self,$heading, $params) = @_;

	my $site = {
		"name" => $params->{'item'},
		"website" => $params->{'website'},
	};
	
	my $array = \@{ $speed_dial->{data}->{$heading} };
	push (@$array, $site);
    
	write_json ($speed_dial);
}

sub remove {
	my ($self, $search) = @_;
	my $count;
    my (@headings) = @{ $speed_dial->{headings} };
	
    LOOP:
	for (@headings) {
        my $array = \@{ $speed_dial->{data}->{$_} };
		$count = 0;
        for my $site (@$array) {
			if ($site->{name} eq $search) {
				splice (@$array, $count, 1);
				last LOOP;
			}
			$count++;
        }
    }
	
	write_json ($speed_dial);
}

__PACKAGE__->meta->make_immutable;

1;
