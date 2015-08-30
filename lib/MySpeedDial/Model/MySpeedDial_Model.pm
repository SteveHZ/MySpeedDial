package MySpeedDial::Model::MySpeedDial_Model;
use Moose;
use namespace::autoclean;

use XML::LibXML;
use XML::LibXML::PrettyPrint;

extends 'Catalyst::Model';

=head1 NAME

MySpeedDial::Model::MySpeedDial_Model - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.
MySpeedDial_Model
05/07/15 - 12/07/15

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

my @array = ();
my $doc;
my $changed = 0;

sub load_xml {
	if (scalar (@array) == 0 || $changed) {
		$doc = XML::LibXML->load_xml ( location => 'root/static/xml/SpeedDial.xml') 
				or die ('Unable to find SpeedDial.xml file');

		@array = ();
		for my $menuTitle ( $doc->findnodes('/Menu/MenuTitle') ) {
			my %group = ();
			my @sites = ();

			my @temp = $menuTitle->getAttributes();
			$group{'heading'} = $temp[0]->getValue();

			for my $menuItem ( $menuTitle->getChildnodes ) {
				my %site = ();
				if ( $menuItem->nodeType() == XML_ELEMENT_NODE ) { # 1
					$site{'name'} = $menuItem->findvalue ('Item');
					$site{'website'} = $menuItem->findvalue ('Website');
					push (@sites, \%site);
				}
			}
			$group{'sites'} = \@sites;
			push (@array, \%group);
		}
	}
	$changed = 0;
	return \@array;
}

sub save_xml {
	my $pp = XML::LibXML::PrettyPrint->new (
		element=> {
			compact => [ qw/Item Website/ ]
		}
	);
	$pp->pretty_print ($doc); # modified in-place

	open my $out,'>','root/static/xml/SpeedDial.xml';
	$doc->toFH ($out);

	$changed = 1;
}

sub get_website {
	my ($self, $item) = @_;
	
	my @sites = $doc->findnodes ("Menu/MenuTitle/MenuItem/
									Item [text()= '$item']/../Website/text ()");
	return $sites[0]->getData();
}

sub edit_site {
	my ($self, $params) = @_;
	my $search = $params->{'item'};

	my (@nodes) = $doc->findnodes ("Menu/MenuTitle/MenuItem/
									Item [text()= '$search']/../Website/text ()");
	
	for my $node(@nodes) {
		$node->removeChildNodes();
		$node->setData ($params->{'website'});
	}
	save_xml ();
}

sub add_new {
	my ($self, $heading, $params) = @_;
	my (@nodes) = $doc->findnodes ("Menu/MenuTitle");

	for my $node(@nodes) {
		if ($node->getAttribute('heading') eq $heading) {
			my $menuItem_node = $doc->createElement("MenuItem");

			my $item_node = $doc->createElement("Item");
			$item_node->appendText($params->{'item'});

			my $website_node = $doc->createElement("Website");
			$website_node->appendText($params->{'website'});

			$menuItem_node->addChild($item_node);
			$menuItem_node->addChild($website_node);

			$node->addChild($menuItem_node);
		}
	}
	save_xml ();
}

sub remove {
	my ($self, $site) = @_;
	
	my @nodes = $doc->findnodes("Menu/MenuTitle/MenuItem[Item/text() = '$site']");
	
	for my $node (@nodes) {
		$node->unbindNode;
	}
	save_xml ();
}

__PACKAGE__->meta->make_immutable;

1;
