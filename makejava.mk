#!/usr/bin/make -f
#
# template start
.PHONY: build clean run test
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar
VPATH = $(shell find -name '*.java' | sed 's%^\./\(.*\)/.*$$%\1%g' | uniq | paste -sd':' )
mainfqn = $(shell find -name '*.java' -exec grep 'void *main.*String' {} \+  | sed 's%^.*/\(.*\)/\(.*\)\.java:.*$$%\1.\2%g' )
mainclass = $(shell echo $(mainfqn) | sed 's%^.*\.\(.*\)$$%\1%g')
sources = $(shell find -name '*.java' | sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')
testclass = $(shell find -name '*.java' -exec grep "import *org.junit" {} \+ | sed 's%^.*/\(.*\)\.java:.*$$%\1%g'| uniq )
# bin existe
classpath = .:bin:src:lib/*
vpath %.class $(subst src,bin,$(VPATH)):bin

build: bin/ lib/junit-platform-console-standalone-1.6.0.jar $(sources:.java=.class) 
	@echo build done

bin/ :
	mkdir bin

lib/junit-platform-console-standalone-1.6.0.jar :
	@mkdir lib
	@wget -nv -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar

%.class: %.java
	javac -d bin -cp $(classpath) $<

clean:
	find bin -name '*.class' -exec rm -v {} \+

run: build $(mainclass:=.class)
ifneq ($(strip $(mainclass)),)
	@java -cp $(classpath) $(mainfqn)
else
	@echo "\e[93mNo main method found\e[0m" 
endif

test: build
#	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass) | sed '/^[[:space:]].*/d' 
	java -jar lib/* -cp $(classpath) --scan-class-path | sed '/^[[ ] .*/d'

prueba :
	@echo "\e[91mVPATH\e[0m" $(VPATH)
	@echo "\e[91mmainfqn\e[0m" $(mainfqn)
	@echo "\e[91mmainclass\e[0m" $(mainclass)
	@echo "\e[91msources\e[0m" $(sources)
	@echo "\e[91mtestclass\e[0m" $(testclass)
	@echo "\e[91mclasspath\e[0m" $(classpath)

### genera un makefile configurado automaticamente
configure :
	@echo "# makefile autoconfigurado on $(CURDIR)" > makefile
	@cat makejava.mk >> makefile
	@make
