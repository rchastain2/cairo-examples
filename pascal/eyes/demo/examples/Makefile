
PC := fpc

PFLAGS := -Mobjfpc
PFLAGS += -Sh

ifdef DEBUG
PFLAGS += -ghl
PFLAGS += -dDEBUG
else
PFLAGS += -dRELEASE
endif

PROGRAMS := $(wildcard *.pas)

ifeq ($(OS),Windows_NT)
	BINARIES := $(patsubst %.pas,%.exe,$(PROGRAMS))
else
	BINARIES := $(patsubst %.pas,%,$(PROGRAMS))
endif

.PHONY: clean

%: %.pas
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv $(BINARIES)
