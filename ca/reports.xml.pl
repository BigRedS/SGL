#! /usr/bin/perl

use strict;
use warnings;
use XML::Simple;
use Data::Dumper;
use 5.010;

my $report = "/mnt/scanachrome/reports/new_xml.xml";

my $xml = XML::Simple->new(KeyAttr=>[]);
my $data = $xml->XMLin("$report");

#rint Dumper ($data->{recs});

print Dumper($data);
