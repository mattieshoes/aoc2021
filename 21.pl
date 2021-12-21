#!/usr/bin/env perl

sub roll {
    my $val = 0;

    for (my $i = 0; $i < 3; $i++) {
        $val += $diceval;
        $diceval++;
        $diceval = 1 if ($diceval > 100);
    }
    $rolls+=3;
    return $val%10;
}

sub dirac {
    my ($apos, $bpos, $ascore, $bscore, $turn) = @_;
    $nodes++;

    return (1,0) if ($ascore >= 21);
    return (0,1) if ($bscore >= 21);

    my $cacheKey = "$apos $bpos $ascore $bscore $turn";
    return (split(/ /, $cache{$cacheKey})) if (exists ($cache{$cacheKey}));

    my @results = (0,0);
    foreach my $key (keys %moves) {
        my @pos = ($apos, $bpos);
        my @score = ($ascore, $bscore);
        $pos[$turn] += $key;
        $pos[$turn] -= 10 if ($pos[$turn] > 10);
        $score[$turn] += $pos[$turn];
        my @res = &dirac($pos[0], $pos[1], $score[0], $score[1], $turn^1);
        $results[0] += $res[0] * $moves{$key};
        $results[1] += $res[1] * $moves{$key};
    }
    $cache{$cacheKey} = join(' ', @results);
    return (@results);
}

$diceval = 1;
@pos = (3, 4);
@score = (0, 0);
$rolls = 0;
$turn = 0;
$nodes = 0;

while ($score[0] < 1000 && $score[1] < 1000) {
    $pos[$turn] += &roll;
    $pos[$turn] -= 10 if ($pos[$turn] > 10);
    $score[$turn] += $pos[$turn];
    $turn ^= 1;
    print "Rolls $rolls - Score $score[0]:$score[1]\n";
}
print $score[$turn] * $rolls . "\n";


%moves = (3, 1, 4, 3, 5, 6, 6, 7, 7, 6, 8, 3, 9, 1);
%cache = ();
@res = &dirac(3, 4, 0, 0, 0, 1);
print join (' ', @res) . "\n";
print "Nodes: $nodes\n";
