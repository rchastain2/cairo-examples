
SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

all: $(TARGETS)

%: %.pas
	@fpc -Mobjfpc -Sh $<
