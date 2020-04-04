#!/usr/bin/make -f
#
# template start
.PHONY: build clean run test
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar
VPATH = $(shell find -name '*.java' | sed 's%^\./\(.*\)/.*$$%\1%g' | uniq | paste -sd':' )
mainfqn = $(shell find -name '*.java' -exec grep 'void *main.*Str' {} \+ | sed 's%^.*/src\(.*\)/\(.*\)\.java:.*$$%\1.\2%' | sed 's%^[/.]%%g'  | sed 's%/%.%g' )
mainclass = $(shell echo $(mainfqn) | sed 's%^.*\.\(.*\)$$%\1%g')
sources = $(shell find -name '*.java' | sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')
testclass = $(shell find -name '*.java' -exec grep "import *org.junit" {} \+ | sed 's%^.*/\(.*\)\.java:.*$$%\1%g'| uniq )
# bin existe
classpath = .:bin:src:lib/*
vpath %.class $(subst src,bin,$(VPATH)):bin
e = \033
greenbg = "\${e}[42m"
redfg = "\${e}[91m"
reset   = "\${e}[0m"
download = echo -e "${e}[92mDownloading junit 5 platform console:${e}[0m"; mkdir -p lib; wget -nv -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar;
makelink = ln -s $(dir $(MAKEFILE_LIST))lib/ lib;

usage : 
	@echo -e Type "${greenbg}" make describe "${reset}" for info or
	@echo -e "${greenbg}" make -f /path/to/makejava/makejava.mk configure "${reset}"
	@echo -e to install makefile in current directory and start to build java project

describe : 
	@echo -e "                ${e}[4m" makejava.mk "${e}[0m"
	@echo
	@echo -e makejava.mk is a makefile to handle the build of a java project.
	@echo -e After cloned from github or copied by others means, from the working 
	@echo -e directory of the java project, execute 
	@echo -e -n "${e}[7m"
	@echo -e make -f /path/to/makejava/makejava.mk configure
	@echo -e -n "${e}[0m"
	@echo -e The above command will create a makefile in the working directory.
	@echo -e Now use this makefile to handle the project. i.e.
	@echo
	@echo -e "make build ; make run ; make test"
	@echo -e 

#build: bin/ lib/junit-platform-console-standalone-1.6.0.jar $(sources:.java=.class) 
build: bin/ lib/ $(sources:.java=.class) 
	@echo -e "${e}[92mBuild done.${e}[0m"

bin/ :
	mkdir -p bin

lib/ : lib/junit-platform-console-standalone-1.6.0.jar
	@:

lib/junit-platform-console-standalone-1.6.0.jar :
	echo $(dir $(MAKEFILE_LIST))
	@if [ -x "makejava.mk" ]; then $(download) else $(makelink) fi

%.class: %.java
	javac -d bin -cp $(classpath) $<

clean:
	@echo -e "${e}[92mCleaning bin dir:${e}[0m" 
	find bin -name '*.class' -exec rm -v {} \+

run: build $(mainclass:=.class)
ifneq ($(strip $(mainclass)),)
	@echo -e "${e}[92mRunning main method found:${e}[0m" 
	@java -cp $(classpath) $(mainfqn)
else
	@echo -e "${e}[93mNo main method found.${e}[0m" 
endif

test: build
	@echo -e "${e}[92mRunning tests:${e}[0m" 
	java -jar lib/* -cp $(classpath) --scan-class-path | sed '/^[[ ] .*/d'

checkvars :
	@echo -e "${e}[91mVPATH${e}[0m" $(VPATH)
	@echo -e "${e}[91mmainfqn${e}[0m" $(mainfqn)
	@echo -e "${e}[91mmainclass${e}[0m" $(mainclass)
	@echo -e "${e}[91msources${e}[0m" $(sources)
	@echo -e "${e}[91mtestclass${e}[0m" $(testclass)
	@echo -e "${e}[91mclasspath${e}[0m" $(classpath)


### genera un makefile configurado automaticamente
configure : lib/
	@echo -e "# makefile autoconfigurado on $(CURDIR)" > makefile
	# $(dir $(MAKEFILE_LIST)) is absolute path
	@cat $(MAKEFILE_LIST) >> makefile
	@echo -e "${e}[40m" makefile written on $(shell pwd) "${e}[0m"
	@echo -e "# use: make build ; make run ; make test"

tips : tipsbanner imports

tipsbanner : 
	@echo -e -n "${e}[94m"
	@echo -e Basics imports needed to include in test classes
	@echo -e "ie. insert easily with: ${e}[95m make imports >> src/ClassTests.java"
	@echo -e "${e}[0m"

imports :
	@echo -e import static org.junit.jupiter.api.Assertions.assertArrayEquals\;
	@echo -e import static org.junit.jupiter.api.Assertions.assertEquals\;
	@echo -e import org.junit.jupiter.api.Test\;
	@echo -e import org.junit.jupiter.api.BeforeEach\;

