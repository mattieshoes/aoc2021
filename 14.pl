#!/usr/bin/env perl

# naive string building implementation for part 1
sub polymerize {
    my $initial = shift;
    my @initial = split(//, $initial);
    my $result = $initial[0];

    for (my $i = 1; $i <= $#initial; $i++) {
        $result .= $rules{$initial[$i-1] . $initial[$i]} . $initial[$i];
    }
    return $result;
}

# keeping hashes of letter pairs
sub polymerize2 {
    my %hash = @_;
    my %result = ();

    foreach my $pair (keys %hash) {
        my ($a, $c) = split(//, $pair);
        my $b = $rules{$pair};
        $result{$a . $b} += $hash{$pair};
        $result{$b . $c} += $hash{$pair};
    }
    return %result;
}


# parse input

@input = `cat input-14.txt`;
#@input = `cat input-14-example.txt`;
chomp @input;

$str = shift @input;
$initial = $str;
shift @input;

%rules = ();
foreach $line (@input) {
    $line =~ /(..) -> (.)/;
    $rules{$1} = $2;
}

# part 1

for ($i = 1; $i <= 10; $i++) {
    $str = &polymerize ($str);
}

%res = ();
@str = split(//, $str);
foreach $letter (@str) {
    $res{$letter}++;
}

$minval = 999999999999;
$maxval = 0;
foreach $letter (keys %res) {
    $minval = $res{$letter} if ($res{$letter} < $minval);
    $maxval = $res{$letter} if ($res{$letter} > $maxval);
}
print $maxval - $minval . "\n";

# part 2

@str = split(//, $initial);
%pairs = ();
for ($i = 1; $i <= $#str; $i++) {
   $pairs{$str[$i-1] . $str[$i]} += 1; 
}


for ($i = 1; $i <= 40; $i++) {
    %pairs = &polymerize2(%pairs);
}
foreach $key (keys %pairs) {
    ($a, $b) = split(//, $key);
    $singles{$a} += $pairs{$key};
    $singles{$b} += $pairs{$key};
}

$min = 99999999999999999;
$max = 0;
foreach $key (keys %singles) {
    $singles{$key}++ if ($singles{$key} % 2 == 1); # first and last letter correction
    $singles{$key} /= 2;
    $min = $singles{$key} if ($singles{$key} < $min);
    $max = $singles{$key} if ($singles{$key} > $max);
}
print $max - $min . "\n";
