
PROGRAMS := $(filter-out cairocolor.pas,$(wildcard *.pas))
BINARIES := $(patsubst %.pas,%,$(PROGRAMS))

all: $(BINARIES)

%: %.pas
	fpc $<

info:
	xdpyinfo | grep dimensions

run: conchoid1
	./$<
	./$< --dark
	./$< 3200 2400
	./$< 3200 2400 --dark
