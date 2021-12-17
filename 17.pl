#!/usr/bin/env perl

sub simulate() {
    my ($xVelocity, $yVelocity, $xmin, $xmax, $ymin, $ymax) = @_;
    my $x = 0;
    my $y = 0;
    my $max_y = 0;

    while(1) {
#        print "Pos $x $y Vel $xVelocity $yVelocity Target $xmin .. $xmax and $ymin .. $ymax\n";
#        my $n = <>;
        $x += $xVelocity;
        $y += $yVelocity;
        $xVelocity -= 1 if ($xVelocity > 0);
        $xVelocity += 1 if ($xVelocity < 0);
        $yVelocity--;
        $max_y = $y if ($y > $max_y);
        return ($max_y) if ($x >= $xmin && $x <= $xmax && $y >= $ymin && $y <= $ymax);
        return -1 if ($y < $ymin && $yVelocity < 0);
        return -1 if ($x < $xmin && $xVelocity <= 0);
        return -1 if ($x > $xmax && $xVelocity >= 0);
    }

}

@input = `cat input-17.txt`;
#@input = `cat input-17-example.txt`;
chomp @input;

$input[0] =~ /^target area: x=(.+)\.\.(.+), y=(.+)\.\.(.+)$/;

$xmin = $1;
$xmax = $2;
$ymin = $3;
$ymax = $4;


$best = 0;
for ($x = 0; $x < $xmax; $x++) {
    for ($y = 0; $y < 1000; $y++) {
        $result = &simulate($x, $y, $xmin, $xmax, $ymin, $ymax);
        if ($result > $best) {
            $best = $result;
            print "$x, $y yields $best\n";
        }
    }
}

$count = 0;
for ($x = 0; $x <= $xmax; $x++) {
    for ($y = -1000; $y < 1000; $y++) {
        $result = &simulate($x, $y, $xmin, $xmax, $ymin, $ymax);
        if ($result > -1) {
            print "$x, $y\n";
            $count++;
        }
    }
}

print "Count: $count\n";
