#!/usr/bin/env perl

sub printGrid {
    my @grid = @_;
    for (my $n = 0; $n <= $#grid; $n++) {
        printf("%2d", $grid[$n]) if ($grid[$n] >= 0);
        print "\n" if ($n % 12 == 11);
    }
    print "\n";
}

sub iterate {
    my @grid = @_;
    my $flashes = 0;

    # every element increases by 1
    foreach my $element (@grid) {
        $element++ if ($element >= 0);
    }

    # all >9 flash, increasing adjacent values by 1
    my @offsets = (-13, -12, -11, -1, 1, 11, 12, 13);
    my $somethingHappened = 1;
    while ($somethingHappened) {
        $somethingHappened = 0;
        my @adj = (0) x ($#grid+1);
        for (my $i = 0; $i <= $#grid; $i++) {
            if ($grid[$i] > 9) {
                $somethingHappened = 1;
                $grid[$i] = 0;
                $flashes++;
                foreach my $offset (@offsets) {
                    $adj[$i+$offset]++;
                }
            }
        }
        for (my $j = 0; $j <= $#grid; $j++) {
            $grid[$j] += $adj[$j] if ($grid[$j] > 0);
        }
    }
    return($flashes, @grid);
}



@input = `cat input-11.txt`;
#@input = `cat input-11-example.txt`;
chomp @input;

@grid = ("-1") x 144;
for ($y = 0; $y <= $#input; $y++) {
    @chars = split(//, $input[$y]);
    for ($x = 0; $x <= $#chars; $x++) {
        $index = ($y + 1) * 12 + $x + 1;
        $grid[$index] = $chars[$x]
    }
}
@orig = @grid;

$sum = 0;
for ($step = 0; $step < 100; $step++) {
    ($flashes, @grid) = &iterate(@grid);
    $sum += $flashes;
}
print "Sum: $sum\n";

@grid = @orig;

for ($step = 1; ; $step++) {
    ($flashes, @grid) = &iterate(@grid);
    if ($flashes == 100) {
        print "Synchronized at step: $step\n";
        last;
    }
}
