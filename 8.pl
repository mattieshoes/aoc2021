#!/usr/bin/env perl

sub solve() {
    my $raw = shift;
    my ($input, $output) = split(/ \| /, $raw);

    
    my @inputs = split(/ /, $input);
    my @trans = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

    # sort letters in inputs for sanity
    for (my $i = 0; $i <= $#inputs; $i++) {
        my @letters = sort(split(//, $inputs[$i]));
        $inputs[$i] = join('', @letters);
    }

    # solve 1, 4, 7, 8 based on number of segments lit
    foreach my $in (@inputs) {
        if (length($in) == 2) {
            $trans[1] = $in;
        } elsif (length($in) == 3) {
            $trans[7] = $in;
        } elsif (length($in) == 4) {
            $trans[4] = $in;
        } elsif (length($in) == 7) {
            $trans[8] = $in;
        }
    }

    # 0, 6, 9 each have 6 segments.  
    # 6 is the only one missing one of the elements from 1.
    # 9 has all the elements of 4
    # 0 must be the remaining one

    my @one = split(//, $trans[1]);
    my @four = split(//, $trans[4]);
    foreach my $in (@inputs) {
        if (length($in) == 6) {
            if ($in !~ /$one[0]/ || $in !~ /$one[1]/) {
                $trans[6] = $in;
            } elsif ($in =~ /$four[0]/ && $in =~ /$four[1]/ && $in =~ /$four[2]/ && $in =~ /$four[3]/) {
                $trans[9] = $in;
            } else {
                $trans[0] = $in;
            }
        }
    }

    # 2, 3, and 5 remain with 5 elements each
    # 3 is the only one to contains all the elements of one
    # 9 contains all the elements of 5
    foreach my $in (@inputs) {
        if (length($in) == 5) {
            if ($in =~ /$one[0]/ && $in =~ /$one[1]/) {
                $trans[3] = $in;
            } else {
                my @parts = split(//, $in);
                my $count =  0;
                foreach my $part (@parts) {
                    if ($trans[9] =~ $part) {
                        $count++;
                    }
                }
                if($count == 5) {
                    $trans[5] = $in;
                } else {
                    $trans[2] = $in;
                }
                
            }
        } 
    }

    #sort outputs, convert to digits, join, and return the 4 digit number
    my @outputs = split(/ /, $output);
    for (my $i = 0; $i <= $#outputs; $i++) {
        my $letters = join('', sort(split(//, $outputs[$i])));

        for (my $j = 0; $j <= $#trans; $j++) {
            if($letters eq $trans[$j]) {
                $outputs[$i] = $j;
            }
        }
    }
    my $out = join('', @outputs);
    return ($out);

}

#@input = `cat input-8-example.txt`;
@input = `cat input-8.txt`;
chomp @input;

$count = 0;
foreach $line (@input) {
    ($in, $out) = split(/ \| /, $line);
    @out = split(/ /, $out);

    foreach $entry (@out) {
        @letters = split(//, $entry);
        if($#letters == 1 || $#letters == 2 || $#letters == 6 || $#letters == 3) {
            $count++;
        }
    }
}
print "$count\n";

$sum = 0;
foreach $line(@input) {
   $sum += &solve($line); 
}
print "$sum\n";
