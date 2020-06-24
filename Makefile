SHELL	:= /bin/bash

all:	jonesforth

jonesforth0: jonesforth.S
	gcc -nostdlib -static -o $@ jonesforth.S

run: jonesforth0 jonesforth.f
	cat jonesforth.f $(PROG) | ./jonesforth0 --no-welcome-message

rc.f: jonesforth0 jonesforth.f strip.f
	$(MAKE) --quiet run PROG=strip.f > $@

rc.o: rc.f
	objcopy -I binary -O elf64-x86-64 -B i386:x86-64 $< $@

jonesforth: jonesforth.S rc.o
	gcc -nostdlib -s -static -Wl,--build-id=none -DRC_START=_binary_rc_f_start -DRC_END=_binary_rc_f_end -o $@ jonesforth.S rc.o

clean:
	rm -f jonesforth0 rc.o rc.f jonesforth perf_dupdrop *~ core .test_*

# Tests.

TESTS	:= $(patsubst %.f,%.test,$(wildcard test_*.f))

test check: $(TESTS)

test_%.test: test_%.f jonesforth
	@echo -n "$< ... "
	@rm -f .$@
	@cat $< <(echo 'TEST') | \
	  ./jonesforth --no-welcome-message 2>&1 | \
	  sed 's/DSP=[0-9]*//g' > .$@
	@diff -u .$@ $<.out
	@rm -f .$@
	@echo "ok"

# Performance.

perf_dupdrop: perf_dupdrop.c
	gcc -O3 -Wall -Werror -o $@ $<

run_perf_dupdrop: jonesforth
	cat perf_dupdrop.f | ./jonesforth --no-welcome-message

.SUFFIXES: .f .test
.PHONY: test check run run_perf_dupdrop
