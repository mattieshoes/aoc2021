#!/usr/bin/env perl

@input = `cat input-1.txt`;
chomp @input;

for($i = 1; $i <= $#input; $i++) {
    $count++ if ($input[$i] > $input[$i-1]);
}
print "Count: $count\n";

$count = 0;
$a = $input[0] + $input[1] + $input[2];
for ($i = 3; $i <= $#input; $i++) {
    $b = $input[$i] + $input[$i-1] + $input[$i-2];
    $count++ if ($b > $a);
    $a = $b;
}
print "Window Count: $count\n";
