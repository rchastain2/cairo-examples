
PC := fpc

PFLAGS := -Mobjfpc
PFLAGS += -Sh
PFLAGS += -ghl

ifdef CAIRO
PFLAGS += -dUSE_CAIRO
endif

PFLAGS += -Fu..

.PHONY: clean

demo: demo.pas image.pas ../eye.pas ../color.pas
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu ../*.o ../*.ppu

distclean: clean
	@rm -fv demo
