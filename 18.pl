#!/usr/bin/env perl

sub parse {
    my $str = shift;
    my @str = split(//, $str);
    my @elements = ();
    my $state = "none";
    my $value = 0;
    foreach $letter (@str) {
        if($state eq "none") {
            if($letter =~ /\d/) {
                $state = "number";
                $value = $value * 10 + $letter;
            } else {
                push(@elements, $letter);
            }
        } elsif ($state eq "number") {
            if($letter =~ /\d/) {
                $value = $value * 10 + $letter;
            } else {
                push(@elements, $value);
                $value = 0;
                $state = "none";
                push(@elements, $letter);
            }
        }
    }
    return @elements;
}

sub explode {
    my @str = @_;

    my $depth = 0;
    my $found = 0;
    my $leftSegment = 0;
    my $rightSegment = 0;
    for (my $i = 0; $i <= $#str; $i++) {
        if ($str[$i] eq '[') {
            $depth++;
            if ($depth > 4) {
                $leftSegment = $i - 1;
            }
        } elsif ($str[$i] eq ']') {
            $depth--;
            if ($depth == 4) {
                $rightSegment = $i + 1;
                last;
            }
        }
    }
    return @str if(!$leftSegment);

    $leftNum = $str[$leftSegment + 2];
    $rightNum = $str[$leftSegment + 4];

    for (my $i = $leftSegment; $i >= 0; $i--) {
        if ($str[$i] =~ /\d+/) {
            $str[$i] += $leftNum;
            last;
        }
    }
    for (my $i = $rightSegment; $i <= $#str; $i++) {
        if ($str[$i] =~ /\d+/) {
            $str[$i] += $rightNum;
            last;
        }
    }
    return (@str[0 .. $leftSegment], "0", @str[$rightSegment .. $#str]);
}

sub spl {
    my @str = @_;
    
    for (my $i = 0; $i <= $#str; $i++) {
        if($str[$i] =~ /\d/ && $str[$i] > 9) {
            my $leftVal = int($str[$i] / 2);
            my $rightVal = $leftVal;
            $rightVal++ if ($str[$i] % 2 == 1);
            splice(@str, $i, 1, '[', $leftVal, ',', $rightVal, ']');
            last;
        }
    }
    return @str;
}

sub reduce {
    my @str = @_;
    my $str = join('', @str);
    my @newStr = &explode(@str);
    my $newStr = join('', @newStr);
    if ($str ne $newStr) {
        return &reduce(@newStr);
    }
    @newStr = &spl(@str);
    $newStr = join('', @newStr);
    if ($str ne $newStr) {
        return &reduce(@newStr);
    }
    return @str;
}

sub add {
    my $leftRef = shift;
    my $rightRef = shift;
    my @arr = ('[', @$leftRef, ',', @$rightRef, ']');
    return @arr;
}

sub magnitude {
    my @str = @_;
    return $str[0] if($#str == 0);
    $depth = 0;
    my $splitLoc = 0;
    for (my $i = 0; $i <= $#str; $i++) {
        if ($str[$i] eq '[') {
            $depth++;
        } elsif ($str[$i] eq ']') {
            $depth--;
        } elsif ($str[$i] eq ',' && $depth == 1) {
            $splitLoc = $i;
        }
    }

    my @left = @str[1 .. ($splitLoc-1)];
    my @right = @str[($splitLoc+1) .. ($#str-1)];

    return (&magnitude(@left) * 3 + &magnitude(@right) * 2);
}

@input = `cat input-18.txt`;
#@input = `cat input-18-example.txt`;
chomp @input;

@result = &parse($input[0]);
for ($i = 1; $i <= $#input; $i++) {
    @n = &parse($input[$i]);
    @result = &add(\@result, \@n);
    @result = &reduce(@result);
}
$mag = &magnitude(@result);
print "Magnitude: $mag\n";

$maxMag = 0;
for ($a = 0; $a <= $#input; $a++) {
    @aStr = &parse($input[$a]);
    for($b = 0; $b <= $#input; $b++) {
        if($b != $a) {
            @bStr = &parse($input[$b]);
            @result = &add(\@aStr, \@bStr);
            @result = &reduce(@result);
            $mag = &magnitude(@result);
            $maxMag = $mag if ($mag > $maxMag);
        }
    }
}
print "Max magnitude: $maxMag\n";

# should have calculated the magnitude of each entry and then used the first and second largest rather than try every single combination
