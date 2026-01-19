
PC := fpc
PFLAGS := -Mobjfpc -Sh
ifdef DEBUG
PFLAGS += -ghl
endif
#PFLAGS += -dGRADIENT

#SOURCES := $(wildcard *.pas)
#SOURCES := $(filter-out ball.pas geometry.pas,$(wildcard *.pas))
#TARGETS := $(SOURCES:%.pas=%)

PROGRAM := demo

default: $(PROGRAM)

%: %.pas
	$(PC) $(PFLAGS) $<

clean:
	rm -fv *.o *.ppu $(PROGRAM)
