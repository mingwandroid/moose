CXX ?= g++
PYTHON_VERSION := $(shell python -c 'import sys;print(sys.version_info[0])')

ifeq ($(PYTHON_VERSION), 2)
	pyconfig := python2-config
else
	pyconfig := python3-config
endif

ifeq (, $(shell which $(pyconfig) 2>/dev/null))
	pyconfig := python-config
endif

$(info Building hit for python $(PYTHON_VERSION) with $(pyconfig))

PYTHONCFLAGS ?= `$(pyconfig) --cflags`
PYTHONLDFLAGS ?= `python -c "import sysconfig; print(sysconfig.get_config_var('LDSHARED').replace('-clang', '-clang++'))"`
HITCPP := hit$(PYTHON_VERSION).cpp

hit: main.cc parse.cc lex.cc braceexpr.cc braceexpr.h lex.h parse.h
	$(CXX) -std=c++11 -g $(CXXFLAGS) $< parse.cc lex.cc braceexpr.cc -o $@

rewrite: rewrite.cc parse.cc lex.cc lex.h parse.h
	$(CXX) -std=c++11 -g $(CXXFLAGS) $< parse.cc lex.cc -o $@

bindings: hit.so

hit.so: parse.cc lex.cc braceexpr.cc $(HITCPP)
	$(PYTHONLDFLAGS) -std=c++11 -w $(PYTHONCFLAGS) $^ -o $@

$(HITCPP): hit.pyx chit.pxd
	cython -$(PYTHON_VERSION) -o $@ --cplus $<

.PRECIOUS: $(HITCPP)

.PHONY: clean bindings

clean:
	rm -f hit hit.so
