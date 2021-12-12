#!/usr/bin/env perl

sub recurse { # uses globals %paths, @curPath and $freeMove because I'm too lazy to pass around references
    my $loc = $curPath[$#curPath];
    
    # end point detection
    if ($loc eq "end") {
        #print join(" ", @curPath) . "\n";
        return 1;
    }

    #iterate through possible moves from here 
    my @moves = split(/,/, $paths{$loc});
    my $sum = 0;
    foreach my $move (@moves) {
        my $fm = $freeMove;
        if ($move eq lc($move) && grep (/^$move$/, @curPath)) {
            next if($freeMove == 1);
            $freeMove = 1;
        }

        push (@curPath, $move);
        $sum += &recurse;
        pop (@curPath);
        $freeMove = $fm;
    }
    return $sum;
}

sub addPath($$) {
    my $a = shift;
    my $b = shift;
    if (exists $paths{$a}) {
        $paths{$a} .= ",$b";
    } else {
        $paths{$a} = $b;
    }
}

@input = `cat input-12.txt`;
#@input = `cat input-12-example.txt`;
chomp @input;

%paths = ();
@curPath = ();
foreach $line (@input) {
    ($a, $b) = split(/-/, $line);
    &addPath($a, $b);
    &addPath($b, $a) if ($a ne "start");
}

$freeMove = 1;
push (@curPath, "start");
$sum = &recurse;
print "Sum: $sum\n";

$freeMove = 0;
$sum = &recurse;
print "Sum: $sum\n";
