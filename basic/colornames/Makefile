
BC := fbc
BFLAGS := -exx -w pedantic

SOURCES := $(wildcard *.bas)
TARGETS := $(SOURCES:%.bas=%)
ifeq ($(OS),Windows_NT)
BINARIES := $(SOURCES:%.bas=%.exe)
else
BINARIES := $(TARGETS)
endif

all: $(TARGETS)

%: %.bas
	@$(BC) $(BFLAGS) $<

clean:
	@rm -fv $(BINARIES)
