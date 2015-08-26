package MySpeedDial::Controller::MySpeedDial;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MySpeedDial::Controller::MySpeedDial - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.
My Speed Dial
v1 22/06/15 - 12/07/15

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path {
    my ( $self, $c ) = @_;

	$c->response->redirect ($c->uri_for ($self->action_for ('home')));
}

sub base :Chained('/') PathPart('myspeeddial') CaptureArgs(0) {
    my ( $self, $c ) = @_;

	$c->stash ( data => $c->model ('MySpeedDial_Model')
						  ->load_xml (),
	)
}
				
sub home :Chained('base') PathPart('home') {
	my ($self, $c) = @_;

	$c->stash ( template => 'Home.tt2' );
}

sub edit :Chained('base') PathPart('edit') {
	my ($self, $c) = @_;
	
	$c->stash (	template => 'editpage.tt2' );
}

sub editxml :Chained('base') PathPart('editxml') Args(2) {
	my ($self, $c, $heading, $item) = @_;

	$c->stash (	template => 'editxmlpage.tt2',
				heading => $heading,
				item => $item,
				website => $c->model ('MySpeedDial_Model')
							 ->getWebsite ($heading, $item),
	);
}

sub do_editxml :Chained('base') PathPart('do_editxml') Args(1) {
	my ($self, $c, $heading) = @_;
	
	my $params = $c->request->params;
#	my $params = params ($c, qw /item website/);
	
	$c->model ('MySpeedDial_Model')
			  ->editSite ($params);

	$c->response->redirect($c->uri_for('home'));
	$c->detach ();
}

sub addnew :Chained('base') PathPart('addnew') Args(1) {
	my ($self, $c, $heading) = @_;
	
#	my $params = params ($c, qw /item website/);

	$c->stash ( template => 'addnew.tt2',
				heading => $heading,
	);
}

sub do_addnew :Chained('base') PathPart('do_addnew') Args(1) {
	my ($self, $c, $heading) = @_;

	my $params = $c->request->params;
#	my $params = params ($c, qw /item website/ );
	
	$c->model ('MySpeedDial_Model')->addNew ($heading, $params);

	$c->response->redirect($c->uri_for('home'));
	$c->detach ();
}

sub remove :Chained('base') PathPart('remove') Args(2) {
	my ($self, $c, $heading, $site) = @_;

	$c->model ('MySpeedDial_Model')->remove ($heading, $site);

	$c->response->redirect($c->uri_for('home'));
	$c->detach ();
}

=head2
sub params {
	my ($c, @params) = @_;
	my $hash = {};
	
	$hash->{$_} = $c->request->params->{$_} foreach (@params);
	return $hash;
}
=cut

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
