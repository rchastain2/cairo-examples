
PC := fpc

PFLAGS := -Mobjfpc
PFLAGS += -Sh
PFLAGS += -Fu..
PFLAGS += -B

ifdef DEBUG
PFLAGS += -ghl
PFLAGS += -dDEBUG
else
PFLAGS += -dRELEASE
endif

SDL2_UNITS := $(HOME)/Documents/pascal/sources/sdl2/units
PFLAGS += -Fu$(SDL2_UNITS)

ifdef CAIRO
PFLAGS += -dUSE_CAIRO
endif

.PHONY: demo clean distclean

demo: demo.pas ../eye.pas $(SDL2_UNITS)
	@$(PC) $(PFLAGS) $<

$(SDL2_UNITS):
	$(error Directory does not exist: $(SDL2_UNITS))

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv demo
