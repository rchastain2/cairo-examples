
SOURCES := $(wildcard *.c)
TARGETS := $(SOURCES:%.c=%)

CC=gcc

all: $(TARGETS)

%: %.c
	@$(CC) $< -o $@ -lcairo -lm

clean:
	@rm -fv $(TARGETS)
