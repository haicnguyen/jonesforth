T{ : GD1 DO I LOOP ; -> }T
T{  4  1 GD1 ->  1 2 3 }T
T{  2 -1 GD1 -> -1 0 1 }T
T{ : GD2 DO I -1 +LOOP ; -> }T
T{  1  4 GD2 -> 4 3 2  1 }T
T{ -1  2 GD2 -> 2 1 0 -1 }T
T{ : GD3 DO 1 0 DO J LOOP LOOP ; -> }T
T{          4        1 GD3 ->  1 2 3   }T
T{          2       -1 GD3 -> -1 0 1   }T
T{ : GD4 DO 1 0 DO J LOOP -1 +LOOP ; -> }T
T{        1          4 GD4 -> 4 3 2 1             }T
T{       -1          2 GD4 -> 2 1 0 -1            }T
T{ : GD5 123 SWAP 0 DO I 4 > IF DROP 234 LEAVE THEN LOOP ; -> }T
T{ 1 GD5 -> 123 }T
T{ 5 GD5 -> 123 }T
T{ 6 GD5 -> 234 }T
T{ : GD6 ( PAT: {0 0},{0 0}{1 0}{1 1},{0 0}{1 0}{1 1}{2 0}{2 1}{2 2} )
     0 SWAP 0 DO
       I 1+ 0 DO
         I J + 3 = IF I UNLOOP I UNLOOP EXIT THEN
         1+
       LOOP
     LOOP ; -> }T
T{ 1 GD6 -> 1 }T
T{ 2 GD6 -> 3 }T
T{ 3 GD6 -> 4 1 2 }T
: TEST ;
