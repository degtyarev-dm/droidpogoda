#!/usr/bin/perl
use v5.14.2;
use File::Slurp qw( read_file write_file );
use DBI  qw(:sql_types);
use Encode qw( decode );

say "[Start]";
my $dbfile='world_weather_stations_index.db';
my $inputFileName='world_weather_stations_index.htm';
my $content = read_file($inputFileName) ;

=head
Описание:
<tr>
  <td>Синопти-<br>ческий индекс</td> 	#0 - index
  <td>Название метеостанции</td>		#1 - name
  <td>Широта, °</td>					#2 - latitude
  <td>Долгота, °</td>					#3 - longitude
  <td>Высота над уровнем моря, м</td>	#4 - height (height AMSL)
  <td>Страна</td>						#5 - country
</tr>
Пример:
 <tr ... >
  <td>98326</td>
  <td>Basa Ab</td>
  <td>141</td>
  <td>120,5</td>
  <td>46</td>
  <td>Philippines</td>
 </tr>
=cut
my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","",   
                                                          {
                                                            RaiseError     => 1,
                                                            sqlite_unicode => 1,
                                                            AutoCommit => 1
                                                          }
                      );

$dbh->do("DROP TABLE IF EXISTS indexes");
$dbh->do("CREATE TABLE indexes('index' INTEGER PRIMARY KEY, name CHAR(255),latitude CHAR(255),longitude CHAR(255),height CHAR(255), country CHAR(255))");
my $sth = $dbh->prepare("INSERT INTO indexes ('index',name,latitude,longitude,height,country) VALUES (?,?,?,?,?,?)");
my $i=0;
while($content=~m{ <tr(\s+.*?)?>\s+
					  <td>(\d{4,5})</td>\s+
					  <td>(.*?)(<.*?>)?</td>\s+
					  <td>([\d,-]+)</td>\s+
					  <td>([\d,-]+)</td>\s+
					  <td>([\d,-]+)?</td>\s+
					  <td>(.*?)</td>\s+
					</tr>
				}xg
	)
{
  $sth->execute($2,decode('cp1251',$3),$5,$6,$7,decode('cp1251',$8));
  # write_file( 'output', {append => 1}, $1." ".$2."  ".$4."  ".$5."  ".$6."  ".$7."\n" ) ;
	$i++;
}

$dbh->disconnect;
say "num = ".$i;
