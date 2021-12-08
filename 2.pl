#!/usr/bin/env perl

@input = `cat input-2.txt`;
chomp @input;

$depth = 0;
$hpos = 0;
foreach $line (@input) {
    ($dir, $dist) = split(/\s+/, $line);

    if ($dir eq "forward") {
        $hpos += $dist;
    } elsif ($dir eq "down") {
        $depth += $dist;
    } elsif ($dir eq "up") {
        $depth -= $dist;
    }
}
print "Depth $depth HPos $hpos : " . $depth * $hpos  . "\n";

$depth = 0;
$hpos = 0;
$aim = 0;
foreach $line (@input) {
    ($dir, $dist) = split(/\s+/, $line);

    if ($dir eq "forward") {
        $hpos += $dist;
        $depth += $dist * $aim;
    } elsif ($dir eq "down") {
        $aim += $dist;
    } elsif ($dir eq "up") {
        $aim -= $dist;
    }
}
print "Depth $depth HPos $hpos : " . $depth * $hpos  . "\n";
