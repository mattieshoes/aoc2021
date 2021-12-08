#!/usr/bin/env perl

#@input = `cat input-7-example.txt`;
@input = `cat input-7.txt`;
chomp @input;

@crabs = split(/,/, $input[0]);

$count = 0;
$best = 0;
$bestval = 999999999999999999;
for ($i = 0; $count < 5; $i++) {
    $dev = 0;
    foreach $crab (@crabs) {
        $n = $crab - $i;
        if($n < 0) { $n *= -1 };
        $dev +=  $n
    }
    if ($dev < $bestval) {
        $best = $i;
        $bestval = $dev;
        $count = 0;
    } else {
        $count++;
    }
}
print "Best: $best, $bestval\n";

$count = 0;
$best = 0;
$bestval = 999999999999999999;
for ($i = 0; $count < 5; $i++) {
    $dev = 0;
    foreach $crab (@crabs) {
        $n = $crab - $i;
        if($n < 0) { $n *= -1 };
        $n = $n * ($n + 1) / 2;
        $dev +=  $n
    }
    if ($dev < $bestval) {
        $best = $i;
        $bestval = $dev;
        $count = 0;
    } else {
        $count++;
    }
}
print "Best: $best, $bestval\n";
