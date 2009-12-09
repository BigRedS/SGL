#! /usr/bin/perl

use strict;
use warnings;

die "$0\n\tGet warranty info from dell.\nUsage\n$0 [SERVICE TAG]\n" if !$ARGV[0];

my $service_tag = $ARGV[0];

use LWP::Simple;
use HTML::TableExtract; # Is in the CPAN, and exists in the debian repositories as libhtml-tableextract-perl

### Make a URL:
#my $url_base = "http://support.euro.dell.com/support/topics/topic.aspx/emea/shared/support/my_systems_info/en/details?c=uk&cs=ukbsdt1&l=en&s=gen";
#my $url = $url_base."&servicetag=".$service_tag;
#my $content = get($url);
#
## Tell HTML::TableExtract to pick out the table(s) whose class is 'contract_table':
#my $table = HTML::TableExtract->new( attribs => { class => "contract_table" } );
#$table->parse($content);
#
### Gimme infos!
#foreach my $ts ($table->tables) {
#	foreach my $row ($ts->rows) {
#		print "", join("\t", @$row), "\n";
#	}
#}


my $url_base = "http://support.euro.dell.com/support/topics/global.aspx/support/my_systems_info/details?c=uk&l=en&s=gen&~ck=anavml&~tab=2";
my $url = $url_base."&servicetag=".$service_tag;
my $content = get($url);

my $table = HTML::TableExtract->new(depth=>6, count=>1, gridmap=>0);
$table->parse($content);
foreach my $ts ($table->tables){
	foreach my $row ($ts->rows){
		print "", join("\t", @$row), "\n";
	}
}


