
%: %.pas
	fpc $<

info:
	xdpyinfo | grep dimensions

run: conchoid1
	./$<
	./$< --dark
