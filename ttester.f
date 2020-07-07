\ This file contains the code for ttester, a utility for testing Forth words,
\ as developed by several authors (see below), together with some explanations
\ of its use.

\ ttester is based on the original tester suite by Hayes:
\ From: John Hayes S1I
\ Subject: tester.fr
\ Date: Mon, 27 Nov 95 13:10:09 PST  
\ (C) 1995 JOHNS HOPKINS UNIVERSITY / APPLIED PHYSICS LABORATORY
\ MAY BE DISTRIBUTED FREELY AS LONG AS THIS COPYRIGHT NOTICE REMAINS.
\ VERSION 1.1
\ All the subsequent changes have been placed in the public domain.
\ The primary changes from the original are the replacement of "{" by "T{"
\ and "}" by "}T" (to avoid conflicts with the uses of { for locals and }
\ for FSL arrays) and modifications so that the stack is allowed to be non-empty
\ before T{.
\ Explanatory material and minor reformatting (no code changes) by
\ C. G. Montgomery March 2009, with helpful comments from David Williams
\ and Krishna Myneni.

\ Usage:

\ The basic usage takes the form  T{ <code> -> <expected stack> }T .
\ This executes  <code>  and compares the resulting stack contents with
\ the  <expected stack>  values, and reports any discrepancy between the
\ two sets of values.
\ For example:
\ T{ 1 2 3 swap -> 1 3 2 }T  ok
\ T{ 1 2 3 swap -> 1 2 2 }T INCORRECT RESULT: T{ 1 2 3 swap -> 1 2 2 }T ok
\ T{ 1 2 3 swap -> 1 2 }T WRONG NUMBER OF RESULTS: T{ 1 2 3 swap -> 1 2 }T ok

\ The word ERROR is vectored, so that its action can be changed by
\ the user (for example, to add a counter for the number of errors).
\ The default action ERROR1 can be used as a factor in the display of
\ error reports.

\ Loading ttester.fs does not change BASE.  Remember that floating point input
\ is ambiguous if the base is not decimal.

BASE @
DECIMAL

VARIABLE ACTUAL-DEPTH			\ stack record
32 CELLS ALLOT CONSTANT ACTUAL-RESULTS
VARIABLE START-DEPTH
VARIABLE ERROR-XT

: ERROR ERROR-XT @ EXECUTE ;   \ for vectoring of error reporting

: EMPTY-STACK	\ ( ... -- ) empty stack; handles underflowed stack too.
  DEPTH START-DEPTH @ < IF
    DEPTH START-DEPTH @ SWAP DO 0 LOOP
  THEN
  DEPTH START-DEPTH @ > IF
    DEPTH START-DEPTH @ DO DROP LOOP
  THEN
;

: ERROR1	\ ( C-ADDR U -- ) display an error message 
		\ followed by the line that had the error.
  TYPE SOURCE TYPE CR			\ display line corresponding to error
  EMPTY-STACK				\ throw away everything else
;

' ERROR1 ERROR-XT !

: T{	( -- )
  DEPTH START-DEPTH !
;

\ record depth and contents of stack.
: ->	( ... -- )
  DEPTH DUP ACTUAL-DEPTH !		\ record depth
  START-DEPTH @ > IF			\ if there is something on the stack
    DEPTH START-DEPTH @ - 0 DO
      ACTUAL-RESULTS I CELLS + !
    LOOP
  THEN
;

\ COMPARE STACK (EXPECTED) CONTENTS WITH SAVED (ACTUAL) CONTENTS.
: }T	( ... -- )
  DEPTH ACTUAL-DEPTH @ = IF		\ if depths match
    DEPTH START-DEPTH @ > IF		\ if there is something on the stack
      DEPTH START-DEPTH @ - 0 DO	\ for each stack item
        ACTUAL-RESULTS I CELLS + @ <> IF
          S" INCORRECT RESULT: " ERROR
          LEAVE
        THEN
      LOOP
    THEN
  ELSE					\ depth mismatch
    S" WRONG NUMBER OF RESULTS: " ERROR
  THEN
;

BASE !
