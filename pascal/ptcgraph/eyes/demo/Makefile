
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

PFLAGS += -Fu..

.PHONY: clean

demo: demo.pas ../eye.pas
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv demo
