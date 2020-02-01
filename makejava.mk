#!/usr/bin/make -f
#
# template start
.PHONY: build clean run test
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar
VPATH = $(shell find -name '*.java' | sed 's%^\./\(.*\)/.*$$%\1%g' | uniq | paste -sd':' )
main = $(shell grep -H -r 'main.*String' */*.java | sed 's%^.*/\(.*java\):.*$$%\1%g' )
sources = $(main) $(shell find -name '*.java' | sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')
testclass = $(shell grep -H -r "import[[:space:]]*org.junit.Test;" tests/*.java | sed 's%^tests/\(.*\)\.java:.*$$%\1%g')
# bin existe
classpath = .:bin:src:lib/*
vpath %.class $(subst src,bin,$(VPATH)):bin
current := $(main) $(shell find src tests  -name '*java' |sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')

#prueba :
#	@echo VPATH $(VPATH)

build: lib/junit-platform-console-standalone-1.6.0.jar $(sources:.java=.class) 
ifeq ($(sources), $(current))
	@echo Updated
else
	@echo Need update
endif
	@echo build done

lib/junit-platform-console-standalone-1.6.0.jar :
	@mkdir lib
	@wget -nv -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar

%.class: %.java
	javac -d bin -cp $(classpath) $<

clean:
	find bin -name '*.class' -exec rm -v {} \+

run: $(main:.java=.class)
	@java -cp $(classpath) $(main:.java=)

test: build
#	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass) | sed '/^[[:space:]].*/d' 
	java -jar lib/* -cp $(classpath) --scan-class-path | sed '/^[[ ] .*/d'
### genera un makefile configurado automaticamente
#auto:
#	@echo "# makefile autoconfigurado on $(CURDIR)" > makefile
#	@cat makejava.mk >> makefile
#	@make
