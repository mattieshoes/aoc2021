#!/usr/bin/env perl

sub rotateY {
    my %beacons = @_;
    my %newBeacons = ();
    foreach my $key (keys %beacons) {
        my ($x, $y, $z) = split(/,/, $key);
        $z *= -1;
        my $newKey = "$z,$y,$x";
        $newBeacons{$newKey} = 1;
    }
    return %newBeacons;
}

sub rotateX {
    my %beacons = @_;
    my %newBeacons = ();
    foreach my $key (keys %beacons) {
        my ($x, $y, $z) = split(/,/, $key);
        $y *= -1;
        my $newKey = "$x,$z,$y";
        $newBeacons{$newKey} = 1;
    }
    return %newBeacons;
}

sub rotateZ {
    my %beacons = @_;
    my %newBeacons = ();
    foreach my $key (keys %beacons) {
        my ($x, $y, $z) = split(/,/, $key);
        $y *= -1;
        my $newKey = "$y,$x,$z";
        $newBeacons{$newKey} = 1;
    }
    return %newBeacons;
}

sub fit {
    my %beacons = @_;

    foreach my $fKey (keys %final) {
        foreach my $bKey (keys %beacons) {
            # assume they two beacons are the same, work out offsets
            my ($fx, $fy, $fz) = split(/,/, $fKey);
            my ($bx, $by, $bz) = split(/,/, $bKey);
            my $xoff = $fx - $bx;
            my $yoff = $fy - $by;
            my $zoff = $fz - $bz;
        
            # count up matching beacons given the offset
            my $matches = 0;
            foreach my $k (keys %beacons) {
                my ($x, $y, $z) = split(/,/, $k);
                $x += $xoff;
                $y += $yoff;
                $z += $zoff;
                my $nk = "$x,$y,$z";
                if (exists $final{$nk}) {
                    $matches++;
                } else {
                    my $fail = 0;
                    for (my $si = 0; $si <= $#solvedX; $si++) {
                        if (abs($solvedX[$si] - $x) < 1000 && 
                            abs($solvedY[$si] - $y) < 1000 && 
                            abs($solvedZ[$si] - $z) < 1000) {
                            $fail = 1;
                            last;
                       }
                    }
                    if ($fail) {
                        last;
                    }
                }
            }
            # if matches is >=12, assume correct
            if ($matches >= 12) {
                print "$xoff $yoff $zoff\n";
                push(@solvedX, $xoff);
                push(@solvedY, $yoff);
                push(@solvedZ, $zoff);
                # add beacons to final, return location
                foreach my $k (keys %beacons) {
                    my ($x, $y, $z) = split(/,/, $k);
                    $x += $xoff;
                    $y += $yoff;
                    $z += $zoff;
                    my $nk = "$x,$y,$z";
                    $final{$nk} = 1;
                }
                return "$xoff $yoff $zoff";
            }
        }
    }
    return 0;
}

# can't be arsed to do rotations right, so it's doing 64 instead of 24
sub fitWithRotation {
    my %b = @_;
    for (my $xrot = 0; $xrot < 4; $xrot++) {
        %b = &rotateX (%b);
        for (my $yrot = 0; $yrot < 4; $yrot++) {
            %b = &rotateY (%b);
            for (my $zrot = 0; $zrot < 4; $zrot++) {
                %b = &rotateZ (%b);
                print ".";
                my $result = &fit(%b);
                if($result) {
                    return $result;
                }
            }
        }
    }
    return 0;
}

@input = `cat input-19.txt`;
#@input = `cat input-19-example.txt`;
chomp @input;

$| = 1; # disable print buffering

@beacons = ();
$state = none;
%hash = ();
$beacon = -1;
foreach $line (@input) {
    if ($line =~ /--- scanner \d+ ---/) {
        $line =~ /--- scanner (\d+) ---/;
        $beacon = $1;
        $beacons[$beacon] = {};
    } elsif ($line =~ /^$/) {
    } else {
        $beacons[$beacon]{$line} = 1;
    }
}

%final = ();
%solved = ();
foreach $key (keys %{$beacons[0]}) {
    $final{$key} = 1;
}
$solved{0} = "0 0 0";
@solvedX  = (0);
@solvedY  = (0);
@solvedZ  = (0);

$unsolved = $#beacons;
while ($unsolved) {
    for($i = 0; $i <= $#beacons;$i++) {
        if(!exists($solved{$i})) {
            print "Scanner $i";
            %b = %{$beacons[$i]};
            $result = &fitWithRotation(%b);
            if($result) {
                $solved{$i} = $result;
            } else { print "\n"; }
        }
    }
    $unsolved = 0;
    for ($i = 0; $i <=$#beacons; $i++) {
        if(!exists($solved{$i})) {
            $unsolved++;
            print "$i unsolved\n";
        }
    }
}
my @list = keys %final;
print "Beacons: " . ($#list+1) . "\n";


$maxDistance = 0;
for ($i = 0; $i < $#beacons; $i++) {
    ($ix, $iy, $iz) = split(/ /, $solved{$i});
    for ($j = $i+1; $j <=$#beacons;$j++) {
        ($jx, $jy, $jz) = split(/ /, $solved{$j});
        $dist = abs($ix - $jx) + abs($iy - $jy) + abs($iz - $jz);
        $maxDistance = $dist if ($dist > $maxDistance);
    }
}
print "Max distance: $maxDistance\n";
