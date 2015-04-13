SHELL:=$(SHELL)

ifndef MATPATH
	MATPATH:=$(shell which matlab)
endif

ifndef PYPATH
	PYPATH:=$(shell which python)
endif

MATDIR:=$(dir $(realpath $(MATPATH)))
PYDIR:=$(dir $(realpath $(PYPATH)))

$(info MATLAB dir: $(MATDIR))
$(info Python dir: $(PYDIR))

PYNAME:=$(notdir $(realpath $(PYPATH)))
PYINCLUDEDIR:=$(PYDIR)../include/$(PYNAME)

MATLAB:=$(join $(MATDIR),matlab)
MEX:=$(join $(MATDIR),mex)
MEXEXT:=$(shell $(join $(MATDIR),mexext))

all: buildmex

buildmex:
	$(MEX) py.cpp -l$(PYNAME) -I$(PYINCLUDEDIR)

clean:
	rm -f py.$(MEXEXT)