!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $adminpw = "ASXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX8";
my $dbh = DBI->connect ("DBI:mysql:host=172.31.8.29;database=dbase_name","database username", $adminpw ,{PrintError => 0, RaiseError => 1});
my $sthshtbl = $dbh->prepare("SHOW TABLES");
$sthshtbl->execute();
while (my $tbl = $sthshtbl->fetchrow_array) {
  my $val = $dbh->selectrow_array("SELECT COUNT(*) FROM $tbl");
    print "$tbl : $val\n";
    }
