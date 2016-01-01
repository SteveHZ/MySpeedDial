package MySpeedDial::Controller::MySpeedDial;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

MySpeedDial::Controller::MySpeedDial - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.
My Speed Dial.pm
v1.00 22/06/15 - 12/07/15
v1.01 29/08/15
v1.02 19/12/15 (using URI plugin)

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path {
    my ( $self, $c ) = @_;

	$c->response->redirect ($c->uri("MySpeedDial.home"));
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

sub editxml :Chained('base') PathPart('editxml') Args(1) {
	my ($self, $c, $item) = @_;

	$c->stash (	template => 'editxmlpage.tt2',
				item => $item,
				website => $c->model ('MySpeedDial_Model')
							 ->get_website ($item),
	);
}

sub do_editxml :Chained('base') PathPart('do_editxml') Args(0) {
	my ($self, $c) = @_;
	my $params = $c->request->params;
	
	$c->model ('MySpeedDial_Model')->edit_site ($params);

	$c->response->redirect ($c->uri("MySpeedDial.home"));
	$c->detach ();
}

sub addnew :Chained('base') PathPart('addnew') Args(1) {
	my ($self, $c, $heading) = @_;

	$c->stash ( template => 'addnew.tt2',
				heading => $heading,
	);
}

sub do_addnew :Chained('base') PathPart('do_addnew') Args(1) {
	my ($self, $c, $heading) = @_;
	my $params = $c->request->params;
	
	$c->model ('MySpeedDial_Model')->add_new ($heading, $params);

	$c->response->redirect ($c->uri("MySpeedDial.home"));
	$c->detach ();
}

sub remove :Chained('base') PathPart('remove') Args(1) {
	my ($self, $c, $site) = @_;

	$c->model ('MySpeedDial_Model')->remove ($site);

	$c->response->redirect ($c->uri("MySpeedDial.home"));
	$c->detach ();
}

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
