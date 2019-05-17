$sourceCSV = "pathxxxxx" ;
$startrow = 0;
$counter = 1 ;
while ($startrow -lt 1188361)
{
Import-CSV $sourceCSV | select-object -skip $startrow -first 594180 | Export-CSV "pathxxxx($counter).csv" -NoClobber;
$startrow += 0 ;
$counter++ ;
 }
