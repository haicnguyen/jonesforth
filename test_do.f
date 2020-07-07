T{ : GD1 DO I LOOP ; -> }T
T{  4  1 GD1 ->  1 2 3 }T
T{  2 -1 GD1 -> -1 0 1 }T
T{ : GD2 DO I -1 +LOOP ; -> }T
T{  1  4 GD2 -> 4 3 2  1 }T
T{ -1  2 GD2 -> 2 1 0 -1 }T
T{ : GD5 123 SWAP 0 DO I 4 > IF DROP 234 LEAVE THEN LOOP ; -> }T
T{ 1 GD5 -> 123 }T
T{ 5 GD5 -> 123 }T
T{ 6 GD5 -> 234 }T
: TEST ;
