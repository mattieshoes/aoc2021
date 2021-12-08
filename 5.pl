#!/usr/bin/env perl

use List::Util qw(min max);

@input = `cat input-5.txt`;
chomp @input;

%vents = ();
foreach $line (@input) {
    $line =~ /^(\d+),(\d+) -> (\d+),(\d+)$/;
    ($x1, $y1, $x2, $y2) = ($1, $2, $3, $4);


    if($x1 == $x2) { # vertical
        for ($i = min($y1, $y2); $i <= max($y1, $y2); $i++) {
            $loc = "$x1,$i";
            if (exists $vents{$loc}) { 
                $vents{$loc}++;
            } else {
                $vents{$loc} = 1;
            }
        }
    } elsif ($y1 == $y2) { # horizontal
        for ($i = min($x1, $x2); $i <= max($x1, $x2); $i++) {
            $loc = "$i,$y1";
            if (exists $vents{$loc}) { 
                $vents{$loc}++;
            } else {
                $vents{$loc} = 1;
            }
        }
    }
}

$sum = 0;
foreach $key (%vents) {
    if($vents{$key} > 1) {
        $sum++;
    }
}
print "Sum: $sum\n";

foreach $line (@input) {
    $line =~ /^(\d+),(\d+) -> (\d+),(\d+)$/;
    ($x1, $y1, $x2, $y2) = ($1, $2, $3, $4);

    #make x always increase
    if ($x2 < $x1) {
        $n = $x1;
        $x1 = $x2;
        $x2 = $n;
        $n = $y1;
        $y1 = $y2;
        $y2 = $n;
    }

    if ($x2 - $x1 == $y2 - $y1) { # up and right
        for ($x = $x1,$y = $y1; $x <= $x2; $x++,$y++) {
            $loc = "$x,$y";
            if (exists $vents{$loc}) { 
                $vents{$loc}++;
            } else {
                $vents{$loc} = 1;
            }
        }
    } elsif ($x2 - $x1 == $y1 - $y2) { # down and right
        for ($x = $x1,$y = $y1; $x <= $x2; $x++,$y--) {
            $loc = "$x,$y";
            if (exists $vents{$loc}) { 
                $vents{$loc}++;
            } else {
                $vents{$loc} = 1;
            }
        }
    }
}

$sum = 0;
foreach $key (%vents) {
    if($vents{$key} > 1) {
        $sum++;
    }
}
print "Sum: $sum\n";
