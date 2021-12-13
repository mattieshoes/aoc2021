#!/usr/bin/env perl

sub fold {
    my $fold = shift;
    $fold =~ /^(.)=(\d+)$/;
    my $dir = $1; 
    my $place = $2;
    my %newPaper = ();


    foreach my $point (keys %paper) {
        my ($x, $y) = split(/,/, $point);

        if ($dir eq "y") {
            if ($y > $place) {
                my $newcoord = $x . "," . ($place * 2 - $y);
                print "$point => $newcoord\n";
                $newPaper{$newcoord} = 1;
            } else {
                $newPaper{$point} = 1;
            }
        } else {
            if ($x > $place) {
                my $newcoord = ($place * 2 - $x) . "," . $y;
                print "$point => $newcoord\n";
                $newPaper{$newcoord} = 1;
            } else {
                $newPaper{$point} = 1;
            }
        }
    }
    %paper = %newPaper;
}

sub printPaper {
    $xmax = 0;
    $ymax = 0;

    foreach my $point (keys %paper) {
        my ($x, $y) = split(/,/, $point);
        $xmax = $x if ($x > $xmax);
        $ymax = $y if ($y > $ymax);
    }

    for (my $y = 0; $y <= $ymax; $y++) {
        for (my $x = 0; $x <= $xmax; $x++) {
            if (exists ($paper{"$x,$y"})) {
                print "#";
            } else {
                print ".";
            }
        }
        print "\n";
    }
    print "\n";

}


@input = `cat input-13.txt`;
#@input = `cat input-13-example.txt`;
chomp @input;

%paper = ();
@folds = ();
foreach $line (@input) {
    $paper{$line} = 1 if($line =~ /^\d+,\d+$/);
    if ($line =~ /fold along/) {
        $line =~ /(.=\d+)$/;
        push(@folds, $1);
    }
}

&printPaper;

foreach $fold (@folds) {
    print "$fold\n";
    &fold($fold);
    &printPaper;
    $count = 0;
    foreach $point (keys %paper) {
        $count++;
    }
    print "Count: $count\n";
}

