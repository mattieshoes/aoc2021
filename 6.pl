#!/usr/bin/env perl

sub iterate() {
   my %fish = @_;
   my %newfish = (0, 0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0);

   $newfish{8} = $fish{0};
   $newfish{7} = $fish{8};
   $newfish{6} = $fish{7} + $fish{0};
   $newfish{5} = $fish{6};
   $newfish{4} = $fish{5};
   $newfish{3} = $fish{4};
   $newfish{2} = $fish{3};
   $newfish{1} = $fish{2};
   $newfish{0} = $fish{1};

   return %newfish;
}


@input = `cat input-6.txt`;
chomp @input;


@fish = split(/,/, $input[0]);

%fish = (0, 0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0);

foreach $f (@fish) {
    $fish{$f}++; 
}

for($i = 1; $i <= 256; $i++) {
    %fish = &iterate(%fish);
    $sum = 0;
    foreach $key (keys %fish) {
       $sum += $fish{$key}; 
    }
    print "$i: $sum\n";
}
