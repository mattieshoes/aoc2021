#!/usr/bin/env perl

sub toInt {
    my @arr = @_;
    my $val = 0;
    foreach my $bit (@arr) {
        $val = $val * 2 + $bit;
    }
    return $val;
}

sub parse {
    my $depth = shift;
    my $maxPackets = shift;
    my @bits = @_;
    my $loc = 0;
    $packets = 0;
    my @retvals = ();

    while(1) { 
#        print "\t" x $depth . "Length : " . ($#bits+1 - $loc) . "\n"; 
        my $version = $bits[$loc] * 4 + $bits[$loc + 1] * 2 + $bits[$loc + 2];
        $versionSum += $version;
        my $type = $bits[$loc + 3] * 4 + $bits[$loc + 4] * 2 + $bits[$loc + 5];
        $loc += 6;
        $packets++;
#        print "\t" x $depth . "Version: $version\n"; 
#        print "\t" x $depth . "Type   : $type ($defs{$type})\n";
        print "\t" x $depth . "$defs{$type}\n";
       
        my $val = 0;
        my @values = ();
        my $offset = 0;
        if ($type == 4) {
            while(1) {
                $val = $val * 16 + 
                       $bits[$loc + 1] * 8 + 
                       $bits[$loc + 2] * 4 + 
                       $bits[$loc + 3] * 2 + 
                       $bits[$loc + 4];
                $loc += 5;
                if(!$bits[$loc - 5]) {
                    last;
                }
            }
            print "\t" x $depth . "Literal: $val\n\n";
            push(@retvals, $val);
        } else {
            my $lengthTypeID = $bits[$loc];
#            print "\t" x $depth . "LTID   : $lengthTypeID\n";
            $loc++;

            if($lengthTypeID) {
                $val = &toInt(@bits[$loc .. $loc+10]);
#                print "\t" x $depth . "Value  : $val packets\n";
                $loc += 11;
                ($offset, @values) = &parse($depth+1, $val, @bits[$loc .. $#bits]);
                $loc += $offset;
                
            } else {
                $val = &toInt(@bits[$loc .. $loc+14]);
 #               print "\t" x $depth . "Value  : $val bits\n";
                $loc += 15;
                ($offset, @values) = &parse($depth+1, 9999, @bits[$loc .. $loc+$val-1]);
                $loc +=$val;
            }
            my $result = 0;
            if ($type == 0) { # sum
                for my $n (@values) {
                    $result += $n;
                }
            } elsif ($type == 1) { # product
                $result = 1;
                for my $n (@values) {
                    $result *= $n;
                }
            } elsif ($type == 2) { # minimum
                $result = 9999999;
                for my $n (@values) {
                    $result = $n if ($n < $result);
                }
            } elsif ($type == 3) { # maximum
                for my $n (@values) {
                    $result = $n if ($n > $result);
                }
            } elsif ($type == 5) { # >
                $result = 1 if ($values[0] > $values[1]);
            } elsif ($type == 6) { # <
                $result = 1 if ($values[0] < $values[1]);
            } elsif ($type == 7) { # =
                $result = 1 if ($values[0] == $values[1]);
            }
            unshift(@retvals, $result);
            print "\t" x $depth . "Return : $result\n"
        }
        if ($packets == $maxPackets) {
            print "Max packets reached\n";
            last;
        }
        $found = 0;
        if ($#bits - $loc < 6) {
            print join ('', @bits[$loc .. $#bits]);
            print " bits left. ending\n";
            last;
        }
    }
    unshift(@retvals, $loc);
    return @retvals;
}

@input = `cat input-16.txt`;
#@input = `cat input-16-example.txt`;
chomp @input;

%trans = ("0", "0000", "1", "0001", "2", "0010", "3", "0011", "4", "0100", "5", "0101", "6", "0110", "7", "0111", "8", "1000", "9", "1001", "A", "1010", "B", "1011", "C", "1100", "D", "1101", "E", "1110", "F", "1111");

%defs = (0, "sum", 1, "product", 2, "min", 3, "max", 4, "literal", 5, ">", 6, "<", 7, "==");

foreach $line (@input) {
    @chars = split(//, $line);

    @bin = ();
    foreach $char (@chars) {
        push(@bin, split(//, $trans{$char}));
    }

    print join ('', @bin) . "\n";
    $versionSum = 0;
    @retvals = &parse(0, 1, @bin);
    print "Version Sum: $versionSum\n";
    print "Return values $retvals[1]\n";
    $asdf = <>
}
