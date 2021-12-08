#!/usr/bin/env perl

sub checkWin {
    my @board = @_;

    #check horizontal
    for (my $r = 0; $r < 5; $r++) {
        my $win = 1;
        for (my $c = 0; $c < 5; $c++) {
            my $index = $r * 5 + $c;
            if($board[$index] != -1) {
                $win = 0;
                break;
            }
        }
        if($win) {
            return $win;
        }
    }

    #check vertical
    for (my $c = 0; $c < 5; $c++) {
        my $win = 1;
        for (my $r = 0; $r < 5; $r++) {
            my $index = $r * 5 + $c;
            if($board[$index] != -1) {
                $win = 0;
                break;
            }
        }
        if($win) {
            return $win;
        }
    }
    return 0;
}

sub solveBoard($) {
    my $num = shift;
    my @board = &getBoard($num);

    for (my $draw = 0; $draw <= $#draws; $draw++) {
        my $d = $draws[$draw];
        for (my $sq = 0; $sq < 25; $sq++) {
            if ($board[$sq] == $d) {
                $board[$sq] = -1;
            }
        }
        if (&checkWin(@board)) {
            my $score = 0;
            foreach my $val (@board) {
                if($val > 0) {
                    $score += $val;
                }
            }
            $score *= $d;
            return ($draw, $score);
        }
    }
}

sub getBoard($) {
    my $num = shift;
    my @board = ();
    for($i = $num * 6 + 2; $i < $num * 6 + 7; $i++) {
        my @vals = split(/\s+/, $input[$i]);
        if($#vals > 4) {
            shift(@vals);
        }
        push(@board, @vals); 
    }
    return @board;
}

@input = `cat input-4.txt`;
chomp @input;

@draws = split(/,/, $input[0]);
my $bestBoard = 0;
my $bestTurns = 99999999999;
my $bestScore = 0;
my $worstBoard = 0;
my $worstTurns = 0;
my $worstScore = 0;

for ($n = 0; $n < 100; $n++) {
    ($t, $s) = &solveBoard($n);
    print "Board $n: Turns: $t $score: $s\n";
    if($t < $bestTurns) {
        $bestBoard = $n;
        $bestTurns = $t;
        $bestScore = $s;
    }
    if ($t > $worstTurns) {
        $worstBoard = $n;
        $worstTurns = $t;
        $worstScore = $s;
    }

}
print("\nBest Board: $bestBoard\n$Best Turns: $bestTurns\nBest Score: $bestScore\n");
print("\nWorst Board: $worstBoard\n$Worst Turns: $worstTurns\nWorst Score: $worstScore\n");

