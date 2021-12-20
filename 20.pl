#!/usr/bin/env perl

sub convert {
    my @bits = @_;
    $val = 0;
    foreach my $bit (@bits) {
        $val = 2 * $val + $bit;
    }
    return $val;
}

sub iterate {
    my %newImage = ();

    # find min x, max x, min y, max y
    my $minX = 999999;
    my $maxX = -999999;
    my $minY = 999999;
    my $maxY = -999999;
    foreach my $light (keys %image) {
        my ($x, $y) = split(/,/, $light);
        $minX = $x if ($x < $minX);
        $minY = $y if ($y < $minY);
        $maxX = $x if ($x > $maxX);
        $maxY = $y if ($y > $maxY);
    }
    $minX -= 5;
    $minY -= 5;
    $maxX += 5;
    $maxY += 5;

    for (my $x = $minX; $x <= $maxX; $x++) {
        for (my $y = $minY; $y <= $maxY; $y++) {
            my @bits = ();
            for (my $dX = -1; $dX <= 1; $dX++) {
                for (my $dY = -1; $dY <= 1; $dY++) {
                    my $coord = ($x + $dX) . "," . ($y+$dY);
                    if (exists $image{$coord}) {
                        push(@bits, 1);
                    } else {
                        push(@bits, 0);
                    }
                }
            }
            my $val = &convert (@bits);
            if($enhancement[$val] == 1) {
                my $newImageCoord = $x . "," . $y;
                $newImage{$newImageCoord} = 1;
            }
        }
    }
    return %newImage;
}

sub printImage {
    my $minX = 999999;
    my $maxX = -999999;
    my $minY = 999999;
    my $maxY = -999999;
    foreach my $light (keys %image) {
        my ($x, $y) = split(/,/, $light);
        $minX = $x if ($x < $minX);
        $minY = $y if ($y < $minY);
        $maxX = $x if ($x > $maxX);
        $maxY = $y if ($y > $maxY);
    }
    for (my $x = $minX; $x <= $maxX; $x++) {
        for (my $y = $minY; $y <= $maxY; $y++) {
            my $coord = $x . "," . $y;
            if (exists $image{$coord}) {
                print "#";
            } else {
                print ".";
            }
        }
        print "\n";
    }

}

sub clipImage {
    my $minX = 999999;
    my $maxX = -999999;
    my $minY = 999999;
    my $maxY = -999999;
    foreach my $light (keys %image) {
        my ($x, $y) = split(/,/, $light);
        $minX = $x if ($x < $minX);
        $minY = $y if ($y < $minY);
        $maxX = $x if ($x > $maxX);
        $maxY = $y if ($y > $maxY);
    }

    $minX += 6;
    $minY += 6;
    $maxX -= 6;
    $maxY -= 6;


    my @keys = keys %image;
    foreach my $key (@keys) {
        my ($x,$y) = split(/,/, $key);
        if ($x < $minX || $x > $maxX || $y < $minY || $y > $maxY) {
            delete $image{$key};
        }
    }

}

@input = `cat input-20.txt`;
chomp @input;

$enhancement = shift @input;
$enhancement =~ s/#/1/g;
$enhancement =~ s/\./0/g;
shift @input;
@enhancement = split(//, $enhancement);
%image = ();
for ($x = 0; $x <= $#input; $x++) {
    $input[$x] =~ s/#/1/g;
    $input[$x] =~ s/\./0/g;
    @line = split (//, $input[$x]);
    for ($y = 0; $y <= $#line; $y++) {
        if ($line[$y] == 1) {
            $coord = "$x,$y";
            $image{$coord} = 1;
        }
    }
}


for ($i = 0; $i < 25; $i++) {
    %image = &iterate;
    %image = &iterate;
    &clipImage;
    @list = keys %image;
    print ($#list +1);
    print "\n";
}


