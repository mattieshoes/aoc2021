#!/usr/bin/env perl

sub carbon {
    my ($pos, @arr) = @_;

    print("carbon $pos $#arr\n");

    my $sum = 0;
    my $count = $#arr+1;
    my @newArr = ();

    if ($#arr <= 0 || $pos > 11) {
        return $arr[0];
    }

    for (my $i = 0; $i <= $#arr; $i++) {
       $sum += substr($arr[$i], $pos, 1);
    }
    my $target = 1; 
    if ($sum * 2 >= $count) {
        $target = 0;
    }
    print "$sum in $count so $target\n";
    foreach my $val (@arr) {
        if (substr($val, $pos, 1) == $target) {
            push(@newArr, $val);
        }
    }
    return &carbon($pos+1, @newArr);
}

sub ox {
    my ($pos, @arr) = @_;

    print("ox $pos $#arr\n");

    my $sum = 0;
    my $count = $#arr+1;
    my @newArr = ();

    if ($#arr <= 0 || $pos > 11) {
        return $arr[0];
    }

    for (my $i = 0; $i <= $#arr; $i++) {
       $sum += substr($arr[$i], $pos, 1);
    }
    my $target = 0; 
    if ($sum * 2 >= $count) {
        $target = 1;
    }
    print "$sum in $count so $target\n";
    foreach my $val (@arr) {
        if (substr($val, $pos, 1) == $target) {
            push(@newArr, $val);
        }
    }
    return &ox($pos+1, @newArr);
}

sub conv {
    my $input = shift;
    my @input = split(//, $input);
    my $val = 0;
    foreach my $bit (@input) {
        $val = $val * 2 + $bit
    }
    return $val;
}

@input = `cat input-3.txt`;
chomp @input;

@sum = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

foreach $line (@input) {
    @arr = split(//, $line);
    for ($i = 0; $i < 12; $i++) {
        $sum[$i] += $arr[$i];
    }
}

$gamma = 0;
$epsilon = 0;
for ($i = 0; $i < 12; $i++) {
    if ($sum[$i] > 500) {
        $gamma = $gamma * 2 + 1;
        $epsilon = $epsilon * 2;
    } elsif ($sum[$i] < 500) {
        $gamma = $gamma * 2;
        $epsilon = $epsilon * 2 + 1;
    }
}
print "$gamma * $epsilon = " . $gamma * $epsilon . "\n";


$oxygen = &ox(0, @input);
$oint = &conv($oxygen);
print "Oxygen: $oxygen ($oint)\n";

$co2 = &carbon(0, @input);
$cint = &conv($co2);

print "Carbon: $carbon ($cint)\n";

print "$oint * $cint = " . $oint * $cint . "\n";


