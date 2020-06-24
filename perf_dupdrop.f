( -*- text -*-
  FORTH repeated DUP DROP * 1000 using ordinary indirect threaded code
  and the assembler primitives.
  $Id: perf_dupdrop.f,v 1.3 2007-10-12 01:46:26 rich Exp $ )

1024 16 * MORECORE

( Print the time passed. )
: PRINT-TIME	( start end -- )
	SWAP - U. CR
;

: PERFORM-TEST	( xt -- )
	( Get everything in the cache. )
	DUP EXECUTE 2DROP
	DUP EXECUTE 2DROP
	DUP EXECUTE 2DROP
	DUP EXECUTE 2DROP
	DUP EXECUTE 2DROP
	DUP EXECUTE 2DROP
	0 0 PRINT-TIME
	( Run the test 10 times. )
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DUP EXECUTE PRINT-TIME
	DROP
;

( ---------------------------------------------------------------------- )
( Make a word which builds the repeated DUP DROP sequence. )
: MAKE-DUPDROP	( n -- )
	BEGIN ?DUP WHILE ' DUP , ' DROP , 1- REPEAT
;

( Now the actual test routine. )
: TEST		( -- start end )
	RDTSC			( Start time )
	[ 1000 MAKE-DUPDROP ]	( 1000 * DUP DROP )
	RDTSC			( End time )
;

: RUN ['] TEST PERFORM-TEST ;
RUN

( ---------------------------------------------------------------------- )
( Try the inlined alternative. )

( Inline the assembler primitive (cfa) n times. )
: *(INLINE) ( cfa n -- )
	BEGIN ?DUP WHILE OVER (INLINE) 1- REPEAT DROP
;

: DUPDROP INLINE DUP INLINE DROP ;CODE

: TEST
	INLINE RDTSC
	[ S" DUPDROP" FIND >CFA 1000 *(INLINE) ]
	INLINE RDTSC
;CODE

: RUN ['] TEST PERFORM-TEST ;
RUN
