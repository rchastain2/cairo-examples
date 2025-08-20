
PC := fpc

PFLAGS := -Mobjfpc
PFLAGS += -Sh
PFLAGS += -ghl
PFLAGS += -Fu..
PFLAGS += -B

ifdef CAIRO
PFLAGS += -dUSE_CAIRO
endif

.PHONY: demo clean distclean

demo: demo.pas image.pas ../eye.pas ../color.pas
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu ../*.o ../*.ppu

distclean: clean
	@rm -fv demo
