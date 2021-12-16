#!/usr/bin/env perl

sub dijkstra {
    my $loc = shift;
    delete $boundary{$loc};

    my @neighbors = ();
    push(@neighbors, $loc+1) if (($loc+1) % $width != 0 && !$visited{$loc + 1});
    push(@neighbors, $loc+$width) if (($loc + $width) <= $#grid && !$visited{$loc + $width});
    push(@neighbors, $loc-1) if ($loc % $width != 0 && !$visited{$loc - 1});
    push(@neighbors, $loc-$width) if ($loc - $width >= 0  && !$visited{$loc - $width});

    foreach my $neighbor (@neighbors) {
        $boundary{$neighbor} = 1;
        my $s = $score{$loc} + $grid[$neighbor];
        if (!exists($score{$neighbor}) || $s < $score{$neighbor}) {
            $score{$neighbor} = $s;
        }
    }
    $visited{$loc} = 1;
}

@input = `cat input-15.txt`;
#@input = `cat input-15-example.txt`;
chomp @input;

# create grid
$height = $#input+1;
$width = length($input[0]);
@grid = ();
foreach $line (@input) {
    push (@grid, split(//, $line));
}

# part 1
%visited = ();
%score = ();
%boundary = ();
$score{0} = 0;
&dijkstra(0);
while (!$visited{$#grid}) {
    $min = 999999;
    $minloc = $#grid;

    foreach $key (keys %boundary) {
        if($score{$key} < $min) {
            $min = $score{$key};
            $minloc = $key;
        }
    }
    &dijkstra($minloc);
}
print "Score: $score{$#grid}\n";

# create stupid part 2 grid
@grid = ();
for ($m = 0; $m < 5; $m++) {
    foreach $line (@input) {
        for ($n = 0; $n < 5; $n++) {
            @vals = split(//, $line);
            foreach $val (@vals) {
                $val += $n + $m;
                $val -= 9 if ($val > 9);
                push(@grid, $val);
            }
        }
    }
}
$height = ($#input+1) * 5;
$width = length($input[0]) * 5;


# part 2
%visited = ();
%score = ();
%boundary = ();
$score{0} = 0;
&dijkstra(0);
while (!$visited{$#grid}) {
    $min = 999999;
    $minloc = $#grid;

    foreach $key (keys %boundary) {
        if($score{$key} < $min) {
            $min = $score{$key};
            $minloc = $key;
        }
    }
    &dijkstra($minloc);
}
print "Score: $score{$#grid}\n";
