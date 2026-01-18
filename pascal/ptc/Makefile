
PC := fpc
PFLAGS := -Mobjfpc -Sh
ifdef DEBUG
PFLAGS += -ghl
endif

SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

all: $(TARGETS)

%: %.pas
	$(PC) $(PFLAGS) $<
