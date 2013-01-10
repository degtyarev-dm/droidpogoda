#!/usr/bin/perl
use strict;
use LWP::Simple qw( get );
use Geo::METAR qw( metar dump );
my $ICAO = $ARGV[0] || "UUOO"; #for test UUOO is Chertovitskoye Airport – Voronezh
my $path = "http://weather.noaa.gov/pub/data/observations/metar/stations/";
my $content = get($path.$ICAO.".TXT");
$content =~ s/.*?($ICAO)/$1/gmso;
# print $content;
my $metar = new Geo::METAR;
$metar->metar($content);
print $metar->dump;
