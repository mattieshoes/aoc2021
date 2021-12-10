#!/usr/bin/env perl

sub parse() {
    my $chunk = shift;

    if ($chunk =~ /\(\)/) {
        $chunk =~ s/\(\)//;
        return &parse($chunk);
    } elsif ($chunk =~ /\[\]/) {
        $chunk =~ s/\[\]//;
        return &parse($chunk);
    } elsif ($chunk =~ /<>/) {
        $chunk =~ s/<>//;
        return &parse($chunk);
    } elsif ($chunk =~ /\{\}/) {
        $chunk =~ s/\{\}//;
        return &parse($chunk);
    }

    print "$chunk - ";

    # "corrupt"
    my @chars = split(//, $chunk);
    for (my $i = 0; $i <= $#chars; $i++) {
        if ($chars[$i] eq ')') {
            print $chars[$i-1] . " $chars[$i] - ";
            return (3, 0);
        } elsif ($chars[$i] eq ']') {
            print $chars[$i-1] . " $chars[$i] - ";
            return (57, 0);
        } elsif ($chars[$i] eq '>') {
            print $chars[$i-1] . " $chars[$i] - ";
            return (25137, 0);
        } elsif ($chars[$i] eq '}') {
            print $chars[$i-1] . " $chars[$i] - ";
            return (1197, 0);
        }
    }

    # "incomplete"
    my $rev = reverse($chunk);
    $rev =~ s/\(/\)/g;
    $rev =~ s/\[/\]/g;
    $rev =~ s/\{/\}/g;
    $rev =~ s/\</\>/g;
    print "$rev - ";

    my $score = 0;
    @chars = split(//, $rev);
    for (my $i = 0; $i <= $#chars; $i++) {
        if ($chars[$i] eq ')') {
            $score = $score * 5 + 1;
        } elsif ($chars[$i] eq ']') {
            $score = $score * 5 + 2;
        } elsif ($chars[$i] eq '}') {
            $score = $score * 5 + 3;
        } elsif ($chars[$i] eq '>') {
            $score = $score * 5 + 4;
        }
    }
    return (0, $score);
}


@input = `cat input-10.txt`;
#@input = `cat input-10-example.txt`;
chomp @input;

$sum = 0;
@ascores = ();
foreach $line (@input) {
    print "$line - ";
    ($cscore, $ascore) = &parse($line);
    print "($cscore $ascore)\n";
    if ($cscore) {
        $sum += $cscore;
    } else {
        push(@ascores, $ascore);
    }
}
print "Sum: $sum\n";

@sorted = sort {$a <=> $b} @ascores;
print "$sorted[$#sorted/2]\n";
