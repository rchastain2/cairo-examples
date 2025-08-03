
PC := fpc

PFLAGS := -Mobjfpc
PFLAGS += -Sh

ifdef DEBUG
PFLAGS += -ghl
PFLAGS += -dDEBUG
else
PFLAGS += -dRELEASE
endif

ifdef CAIRO
PFLAGS += -dUSE_CAIRO
endif

SDL2_UNITS := $(HOME)/Documents/pascal/sources/sdl2/units

ifeq ($(MAKECMDGOALS),demosdl)
PFLAGS += -Fu$(SDL2_UNITS)
endif

PROGRAMS := $(filter-out eye.pas image.pas,$(wildcard *.pas))

ifeq ($(OS),Windows_NT)
	BINARIES := $(patsubst %.pas,%.exe,$(PROGRAMS))
else
	BINARIES := $(patsubst %.pas,%,$(PROGRAMS))
endif

.PHONY: clean

default: demo

all: demo demosdl

%: %.pas eye.pas
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv $(BINARIES)
