
UNITS=/home/roland/Documents/pascal/sources/sdl2/units
# https://github.com/PascalGameDevelopment/SDL2-for-Pascal

SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

all: $(TARGETS)

%: %.pas
	@fpc -Mobjfpc -Sh -Fu$(UNITS) $<

clean:
	rm -f *.o

distclean: clean
	rm -f $(TARGETS)
