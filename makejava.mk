#!/usr/bin/make -f
#
# template start
.PHONY: build clean run test
# couse here-document, on class rule, is undivisible
.ONESHELL :
# couse bash echo accept -e to interpret escape codes
SHELL = /bin/bash
# https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar
VPATH = $(shell find -name '*.java' | sed 's%^\./\(.*\)/.*$$%\1%g' | uniq | paste -sd':' )
# the following line has a bug... or the use of its output do. the === in main is for disable this behave
mainfqn = $(shell find -name '*.java' -exec grep 'void *ma===in.*Str' {} \+ | sed 's%^.*/src\(.*\)/\(.*\)\.java:.*$$%\1.\2%' | sed 's%^[/.]%%g'  | sed 's%/%.%g' )
mainclass = $(shell echo $(mainfqn) | sed 's%^.*\.\(.*\)$$%\1%g')
sources = $(shell find -name '*.java' | sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')
testclass = $(shell find -name '*.java' -exec grep "import *org.junit" {} \+ | sed 's%^.*/\(.*\)\.java:.*$$%\1%g'| uniq )
# bin existe
classpath = .:bin:src:lib/*:zip/*
mockitojars = zip/mockito-all-2.0.2-beta.jar
# mockitojars = mok/mockito-core-3.3.3.jar:mok/byte-buddy-1.10-5.jar:mok/byte-buddy-agent-1.10.5.jar:mok/objenesis-2.6.jar

vpath %.class $(subst src,bin,$(VPATH)):bin
e = \033
underscore = "\${e}[4m"
inverse = "\${e}[7m"
greenbg = "\${e}[42m"
graybg = "\${e}[40m"
magentafg = "\${e}[95m"
bluefg = "\${e}[94m"
yellowfg = "\${e}[93m"
greenfg = "\${e}[92m"
yellowfg = "\${e}[93m"
bluefg = "\${e}[94m"
redfg = "\${e}[91m"
reset   = "\${e}[0m"
downloadJUnit = echo "${greenfg}Downloading junit 5 platform console:${reset}"; mkdir -p lib; wget -nv -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar;
downloadMockito = echo "${greenfg}Downloading mockito 2.0.2:${reset}"; mkdir -p zip; wget -nv -P zip https://repo1.maven.org/maven2/org/mockito/mockito-all/2.0.2-beta/mockito-all-2.0.2-beta.jar;
makelinkLib = ln -s $(dir $(MAKEFILE_LIST))lib/ lib;
makelinkZip = ln -s $(dir $(MAKEFILE_LIST))zip/ zip;

packagename = $(shell cat CurrentPackageName)

usage : 
	@echo -e For info type:
	@echo -e "${inverse}" make describe "${reset}"
	@echo -e To install makefile in current directory and start to build java project:
	@echo -e "${inverse}" make -f /path/to/makejava/makejava.mk configure "${reset}"

describe : 
	@echo -e "                ${underscore}" makejava.mk "${reset}"
	@echo
	@echo -e makejava.mk is a makefile to handle the build of a java project.
	@echo -e After cloned from github or copied by others means, from the working 
	@echo -e directory of the java project, execute 
	@echo -e -n "${inverse}"
	@echo -e make -f /path/to/makejava/makejava.mk configure
	@echo -e -n "${reset}"
	@echo -e The above command will create a makefile in the working directory.
	@echo -e Now use this makefile to handle the project. i.e.
	@echo
	@echo -e "make build ; make run ; make test"
	@echo -e 

#build: bin/ lib/junit-platform-console-standalone-1.6.0.jar $(sources:.java=.class) 
build: bin/ lib/ zip/ $(sources:.java=.class) 
	@echo -e "${greenfg}Build done.${reset}"

bin/ :
	mkdir -p bin

lib/ : lib/junit-platform-console-standalone-1.6.0.jar
	@:

zip/ : zip/mockito-all-2.0.2-beta.jar
	@:

lib/junit-platform-console-standalone-1.6.0.jar :
	@if [ -x "makejava.mk" ]; then $(downloadJUnit) else $(makelinkLib) fi
	@if [ -d lib ]; then printf "lib done\n"; fi

zip/mockito-all-2.0.2-beta.jar :
	@if [ -x "makejava.mk" ]; then $(downloadMockito) else $(makelinkZip) fi
	@if [ -d zip ]; then printf "zip done\n"; fi

%.class : %.java
	@echo -e "${greenfg}Compiling :${reset}" 
	javac -d bin -cp $(classpath) $<

clean:
	@echo -e "${greenfg}Cleaning bin dir:${reset}" 
	find bin -name '*.class' -exec rm -v {} \+

run: build $(mainclass:=.class)
ifneq ($(strip $(mainclass)),)
	@echo -e "${greenfg}Running main method found:${reset}" 
	@java -cp $(classpath) $(mainfqn)
else
	@echo -e "${yellowfg}No main method found.${reset}" 
endif

test : build
	@echo -e "${greenfg}Running tests:${reset}" 
	@if [ ! -f "Engines" ]; then echo "--include-engine junit-jupiter --exclude-engine junit-vintage" > Engines ; fi
	@if [ ! -f "TestClasses" ]; then echo "--scan-class-path" > TestClasses ; else echo -e "${greenfg}"; echo "Testing classes in TestClasses file"; cat TestClasses | sed 's/-c /-> /g'; echo -e "${reset}"; fi
	#java -jar lib/* @TestClasses -cp $(classpath):$(mockitojars)  @Engines
#	java -jar lib/* @TestClasses -cp $(classpath) @Engines | sed '/^[[ ] .*/d'
	java -jar lib/* @TestClasses -cp $(classpath):$(mockitojars)  @Engines 2>&1 | sed -e '/.*=>.*/p' -e '/^[[ ] .*/d' -e '/^WARNING.*/d' 

checkvars :
	@echo -e "${redfg}VPATH${reset}" $(VPATH)
	@echo -e "${redfg}MAKEFILE_LIST${reset}" $(MAKEFILE_LIST)
	@echo -e "${redfg}mainfqn${reset}" $(mainfqn)
	@echo -e "${redfg}mainclass${reset}" $(mainclass)
	@echo -e "${redfg}sources${reset}" $(sources)
	@echo -e "${redfg}testclass${reset}" $(testclass)
	@echo -e "${redfg}classpath${reset}" $(classpath)


### genera un makefile configurado automaticamente
configure : lib/ zip/
ifneq (,$(wildcard ./makejava.mk))
	@echo "Still on makejava directory. Nothing done."
else
	@printf "# makefile autoconfigurado on $(CURDIR)\n" > makefile
	# $(dir $(MAKEFILE_LIST)) is absolute path
	@cat $(MAKEFILE_LIST) >> makefile
	@printf "${graybg} makefile written on $(shell pwd) ${reset}\n"
	@printf "# use: make build ; make run ; make test\n"
endif

tips : tipsbanner imports

tipsbanner : 
	@echo -e -n "${bluefg}"
	@echo -e Basics imports needed to include in test classes
	@echo -e "ie. insert easily with: ${magentafg} make imports >> src/ClassTests.java"
	@echo -e "${reset}"

imports :
	@if [ -f "CurrentPackageName" ]; then cat CurrentPackageName; else echo package paquete\; ; fi
	@echo 
	@echo -e import static org.junit.jupiter.api.Assertions.*\;
	@echo -e import static org.mockito.Mockito.*\;
	@echo -e import org.junit.jupiter.api.*\;
	@echo 

update :
	@echo -e "${bluefg}Updating makefile${reset}"
	@make -f ~/makejava/makejava.mk configure

class :
	@echo Creating ${classname}.java on  ${packagename}
	$(shell cat > class.sh <<EOF
	export packagename=\$$(cat CurrentPackageName)
	echo -e 'package \$${packagename};\n\npublic class \$${classname} {\n}' > src/\$${packagename//.//}/\$${classname}.java
	EOF
	)
	. ./class.sh && rm class.sh
