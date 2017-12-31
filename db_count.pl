#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $adminpw = "your-admin-password goes here";
my $dbh = DBI->connect ("DBI:mysql:host=xxx.xx.x.xx;database=yourdb","yourdb-user", $adminpw ,{PrintError => 0, RaiseError => 1});
my $sthshtbl = $dbh->prepare("SHOW TABLES");
$sthshtbl->execute();
while (my $tbl = $sthshtbl->fetchrow_array) {
  my $val = $dbh->selectrow_array("SELECT COUNT(*) FROM $tbl");
  print "$tbl : $val\n";
}

