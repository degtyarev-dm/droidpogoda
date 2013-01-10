#!/usr/bin/perl
use strict;
use Geo::WeatherNWS;
use Data::Dumper;
my $Report=Geo::WeatherNWS::new();
$Report->getreport('uuoo'); 

# Check for errors
if ($Report->{error})
{
  print "$Report->{errortext}\n";
}

print Dumper $Report;
# for(keys %{$Report})
# {
# 	print $_.": ".$Report->{$_}."\n";
# }