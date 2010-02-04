#! /usr/bin/perl

use strict;
use warnings;
use Net::LDAP;

## Read config file and create %config

my $config_file = ".config";
my %config;
open (F, "<$config_file");
while(<F>){
	s/\#.+//;
	my ($key,$value)=(split(/:/, $_))[0,1];
	$config{$key}=$value;
}
close F;



my $ad = Net::LDAP->new("ldap://$config{'server'}") or die("Could not connect to LDAP server..");
$ad->bind($config{'user'},$config{'password'});

my $searchbase = 'OU=Users,OU=Scanachrome,DC=SGL,DC=GROUP';

#my $filter = "memberof=CN=Skelmersdale Users,OU=Security,OU=Groups,OU=Scanachrome,DC=SGL,DC=GROUP";
my $filter = "memberof=CN=Users,OU=Builtin,DC=SGL,DC=GROUP";

my $attrs = 'sn';

my $results = $ad->search(base=>$searchbase,filter=>$filter,attrs=>$attrs);

my $count = $results->count;

print "$count";



$ad->unbind();

