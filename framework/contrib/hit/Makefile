CXX ?= g++

# some systems have python2 but no python2-config command - fall back to python-config for them
pyconfig := python2-config
ifeq (, $(shell which python2-config 2>/dev/null))
  pyconfig := python-config
endif

PYTHONCFLAGS ?= `$(pyconfig) --cflags`
PYTHONLDFLAGS ?= `python -c "import sysconfig; print(sysconfig.get_config_var('LDSHARED'))"`

hit: main.cc parse.cc lex.cc braceexpr.cc braceexpr.h lex.h parse.h
	$(CXX) -std=c++11 -g $(CXXFLAGS) $< parse.cc lex.cc braceexpr.cc -o $@

rewrite: rewrite.cc parse.cc lex.cc lex.h parse.h
	$(CXX) -std=c++11 -g $(CXXFLAGS) $< parse.cc lex.cc -o $@

bindings: hit.so

hit.so: parse.cc lex.cc hit.cpp
	$(CXX) -std=c++11 -w $(PYTHONCFLAGS) $(PYTHONLDFLAGS) $^ -o $@

hit.cpp: hit.pyx chit.pxd
	cython --cplus $<

.PRECIOUS: hit.cpp

.PHONY: clean bindings

clean:
	rm -f hit hit.so
