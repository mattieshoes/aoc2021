#!/usr/bin/env perl

sub getVal($$) {
    my $x = shift;
    my $y = shift;

    if($y < 0 || $y >= $height || $x < 0 || $x >= $width) {
        return 9;
    }
    my @row = split(//, $input[$y]);
    return $row[$x];
}

sub setVal($$$) {
    my $x = shift;
    my $y = shift;
    my $val = shift;

    if ($y < 0 || $x < 0 || $y >= $height || $x >= $width) {
        return;
    }
    my @row = split(//, $input[$y]);
    $row[$x] = $val;
    $input[$y] = join('', @row);
}

sub check($$) {
    my $x = shift;
    my $y = shift;

    my $val = &getVal($x, $y);
    if( &getVal($x, $y+1) <= $val || &getVal($x, $y-1) <= $val || 
        &getVal($x+1, $y) <= $val || &getVal($x-1, $y) <= $val) {
        return 0;
    }
    return $val + 1;
}

sub basinSize($$) {
    my $x = shift;
    my $y = shift;

    my $val = &getVal($x, $y);

    return 0 if ($val == 9 || $val == 0);

    &setVal($x, $y, 0);
    return (1 + &basinSize($x-1, $y) + &basinSize($x+1, $y) + 
                &basinSize($x, $y-1) + &basinSize($x, $y+1));
}

@input = `cat input-9.txt`;
#@input = `cat input-9-example.txt`;
chomp @input;

$width = length($input[0]);
$height = $#input + 1;


$sum = 0;
for ($x = 0; $x < $width;$x++) {
    for ($y = 0; $y < $height; $y++) {
        $sum += &check($x, $y);
    }
}
print "Sum: $sum\n";

for ($i = 0; $i <= $#input; $i++) {
    $input[$i] =~ s/[0-8]/1/g;
}

@basins = ();
for ($x = 0; $x < $width; $x++) {
    for ($y = 0; $y < $height; $y++) {
        $val = &basinSize($x, $y);
        if($val) {
            push(@basins, $val);
        }
    }
}
@basins = sort {$b <=> $a} @basins;
print $basins[0] * $basins[1] * $basins[2]  . "\n";
