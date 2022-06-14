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
mainfqn = $(shell find -name '*.java' -exec grep 'void *main.*Str' /dev/null  {} \+ | sed 's%^.*/src\(.*\)/\(.*\)\.java:.*$$%\1.\2%' | sed 's%^[/.]%%g'  | sed 's%/%.%g' )
mainclass = $(shell echo $(mainfqn) | sed 's%^.*\.\(.*\)$$%\1%g')
sources = $(shell find -name '*.java' | sed 's%^.*/\(.*\)$$%\1%g' | paste -sd' ')
testclass = $(shell find -name '*.java' -exec grep "import *org.junit" {} \+ | sed 's%^.*/\(.*\)\.java:.*$$%\1%g'| uniq )
# bin existe
classpath = .:bin:src:.makejava/lib/*:.makejava/zip/*
mockitojars = .makejava/zip/mockito-all-2.0.2-beta.jar
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
downloadJUnit = echo "${greenfg}Downloading junit 5 platform console:${reset}"; mkdir -p .makejava/lib; wget -nv -P .makejava/lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar;
downloadMockito = echo "${greenfg}Downloading mockito 2.0.2:${reset}"; mkdir -p .makejava/zip; wget -nv -P .makejava/zip https://repo1.maven.org/maven2/org/mockito/mockito-all/2.0.2-beta/mockito-all-2.0.2-beta.jar;
makelinkLib = ln -s $(dir $(MAKEFILE_LIST)).makejava/lib/ .makejava/lib;
makelinkZip = ln -s $(dir $(MAKEFILE_LIST)).makejava/zip/ .makejava/zip;


ifeq (,${packagename})
packagename = $(shell [ -f .makejava/CurrentPackageName ] && cat .makejava/CurrentPackageName)
else
endif

usage :
	@echo -e For info type:
	@echo -e "${inverse}" make describe "${reset}"
	@echo -e To install makefile in current directory:
	@echo -e "${inverse}" make -f /path/to/makejava/makejava.mk raw "${reset}"
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
	@echo -e See what and how classes can be created with\: make creates
	@echo -e


build: bin/ .makejava/lib/ .makejava/zip/ $(sources:.java=.class)
	@echo -e "${greenfg}Build done.${reset}"

bin/ :
	mkdir -p bin

.makejava :
	mkdir -p .makejava

.makejava/lib/ : .makejava .makejava/lib/junit-platform-console-standalone-1.6.0.jar
	@:

.makejava/zip/ :  .makejava .makejava/zip/mockito-all-2.0.2-beta.jar
	@:

.makejava/lib/junit-platform-console-standalone-1.6.0.jar :
	@if [ -x "makejava.mk" ]; then $(downloadJUnit) else $(makelinkLib) fi
	@if [ -d .makejava/lib ]; then printf "lib done\n"; fi

.makejava/zip/mockito-all-2.0.2-beta.jar :
	@if [ -x "makejava.mk" ]; then $(downloadMockito) else $(makelinkZip) fi
	@if [ -d .makejava/zip ]; then printf "zip done\n"; fi

%.class : %.java
	@echo -e "${greenfg}Compiling : $< ${reset}"
	javac ${option} -encoding $(shell file -i $< | sed 's/^.*charset=//g') -d bin -cp $(classpath) $<

clean:
	@echo -e "${greenfg}Cleaning bin dir:${reset}"
	find bin -name '*.class' -exec rm -v {} \+

rebuild : clean build
	@:

run: build $(mainclass:=.class)
ifneq ($(strip $(mainclass)),)
	@echo -e "${greenfg}Running main method found:${reset}"
	@java -cp $(classpath) $(mainfqn) $(ARG1) $(ARG2) $(ARG3) $(ARG4)
else
	@echo -e "${yellowfg}No main method found.${reset}"
endif

adminfiles :
	@if [ ! -f ".makejava/Engines" ]; then echo "--include-engine junit-jupiter --exclude-engine junit-vintage" > .makejava/Engines ; fi
	@if [ ! -f ".makejava/JUnitConsoleLauncherOptions" ]; then echo "--scan-class-path" > .makejava/JUnitConsoleLauncherOptions ; else echo -e "${greenfg}"; echo "Testing classes in .makejava/JUnitConsoleLauncherOptions file"; cat .makejava/JUnitConsoleLauncherOptions | sed 's/-c /-> /g'; echo -e "${reset}"; fi

testall :
	java -jar .makejava/lib/* --scan-class-path $(junitoption) -cp $(classpath):$(mockitojars)  @.makejava/Engines 2>&1 | sed -e '/.*=>.*/p' -e '/^[[ ] .*/d' -e '/^WARNING.*/d'

testv : adminfiles build
	java -jar .makejava/lib/* @.makejava/JUnitConsoleLauncherOptions -cp $(classpath):$(mockitojars)  @.makejava/Engines

test : adminfiles build
	#@clear
	@echo -e "${greenfg}Running tests:${reset}"
	#java -jar lib/* @.makejava/JUnitConsoleLauncherOptions -cp $(classpath) @.makejava/Engines | sed '/^[[ ] .*/d'
	java -jar .makejava/lib/* @.makejava/JUnitConsoleLauncherOptions $(junitoption) -cp $(classpath):$(mockitojars)  @.makejava/Engines 2>&1 | sed -e '/.*=>.*/p' -e '/^[[ ] .*/d' -e '/^WARNING.*/d'

checkvars :
	@echo -e "${redfg}VPATH${reset}" $(VPATH)
	@echo -e "${redfg}MAKEFILE_LIST${reset}" $(MAKEFILE_LIST)
	@echo -e "${redfg}mainfqn${reset}" $(mainfqn)
	@echo -e "${redfg}mainclass${reset}" $(mainclass)
	@echo -e "${redfg}sources${reset}" $(sources)
	@echo -e "${redfg}testclass${reset}" $(testclass)
	@echo -e "${redfg}classpath${reset}" $(classpath)
	@echo -e "${redfg}classname${reset}" $(classname)
	@echo -e "${redfg}packagename${reset}" $(packagename)
	@echo -e "${redfg}.FEATURES:${reset}" $(.FEATURES)
	@echo -e "${redfg}ARG${reset}" $(ARG)

### genera un makefile configurado automaticamente
raw : 
ifneq (,$(wildcard ./makejava.mk))
	@echo "Still on makejava directory. Nothing done."
else
	@#@printf "# makefile autoconfigurado on $(CURDIR)\n" > makefile
	@# $(dir $(MAKEFILE_LIST)) is absolute path
	@# @cat $(MAKEFILE_LIST) >> makefile
	@ln -s $(MAKEFILE_LIST) makefile
	@printf "${graybg}makefile symlink created on $(shell pwd) ${reset}\n"
	@printf "# use: make build ; make run ; make test\n"
endif

configure : raw .makejava/lib/ .makejava/zip/


tips : tipsbanner imports creates

tipsbanner :
	@echo -e -n "${bluefg}"
	@echo -e Basics imports needed to include in test classes
	@echo -e "ie. insert easily with: ${magentafg} make imports >> src/ClassTests.java"
	@echo -e "${reset}"

creates :
	@echo -e -n "${bluefg}"
	@echo -e "Create classes, testclasses and intefaces on packages, ie:"
	@echo -e "${magentafg}"
	@echo -e "# classname=Dog packagename=ar.edu.unq.animals make class"
	@echo -e "# classname=CatTest packagename=ar.edu.unq.animals make testclass"
	@echo -e "# interfacename=IMammal packagename=ar.edu.unq.animals make interface"
	@echo -e "${reset}"

packagehead = package ${packagename}\;\\n\\n
imports = import static org.junit.jupiter.api.Assertions.*\;\\n\import static org.mockito.Mockito.*\;\\nimport org.junit.jupiter.api.*\;\\n\\n
classdef = public class ${classname} {\\n\\n"    "public ${classname}\(\) {\\n"        super();"\\n"    "}\\n}
testdef =  public class ${classname} {\\n\\n"    "@DisplayName\(\" \"\)\\n"    "@Test\\n"    "void test1\(\) {\\n"        "fail\(\"Test aun no implementado\"\)\;\\n"    "}\\n}
interfacedef =  public interface ${interfacename} {\\n}

imports :
	@echo -e $(packagehead)$(imports)

update :
	@echo -e "${bluefg}Updating makefile${reset}"
	@make -f ~/makejava/makejava.mk configure


packagefn = $(subst .,/,${packagename})/
packageclassfn = $(packagefn)${classname}.java
packageinterfacefn = $(packagefn)${interfacename}.java
testdir = test/
srcdir = src/

$(testdir)$(packagefn) :
	mkdir -p $(testdir)$(packagefn)

$(srcdir)$(packagefn) :
	mkdir -p $(srcdir)$(packagefn)

interface : $(srcdir)$(packagefn)
ifneq (,$(word 2, ${interfacename} ${packagename}))
	@echo Creating ${interfacename}.java on ${packagename}
	@echo -e $(packagehead)$(interfacedef) > $(srcdir)$(packageinterfacefn)
else
	$(if ${interfacename}${packagename}, @echo Just ${interfacename}${packagename} has been defined., @echo Nothing defined.)
endif

testclass : $(testdir)$(packagefn)
ifneq (,$(word 2, ${classname} ${packagename}))
	@echo Creating ${classname}.java on ${packagename}
	@echo -e $(packagehead)$(imports)$(testdef) > $(testdir)$(packageclassfn)
else
	$(if ${classname}${packagename}, @echo Just ${classname}${packagename} has been defined., @echo Nothing defined.)
endif

class : $(srcdir)$(packagefn)
ifneq (,$(word 2, ${classname} ${packagename}))
	@echo Creating ${classname}.java on ${packagename}
	@echo -e $(packagehead)$(classdef) > $(srcdir)$(packageclassfn)
else
	$(if ${classname}${packagename}, @echo Just ${classname}${packagename} has been defined., @echo Nothing defined.)
endif

##
## https://junit.org/junit5/docs/5.1.0-M1/user-guide/#running-tests-console-launcher
## Solo algunos ejemplos para junitoption env var passing
## -p, --select-package <String>                 Select a package for test discovery. This option can be repeated.
## -c, --select-class <String>                   Select a class for test discovery. This option can be repeated. ie: com.java.ClassName
## -m, --select-method <String>                  Select a method for test discovery. This ##
##
## por ejemplo para la clase de test CaseTest en test/ar/edu/unq/po2/CaseTest.java hacemos:
## --select-class ar.edu.unq.po2.CaseTest
##
## ### guile support experiment
## define GUILEIO
## ;; A simple Guile IO library for GNU make (from: info make)
##
## (define MKPORT #f)
##
## (define (mkopen name mode)
## 	(set! MKPORT (open-file name mode))
## 	#f)
##
## (define (mkwrite s)
## 	(display s MKPORT)
## 	(newline MKPORT)
## 	#f)
##
## (define (mkclose)
## 	(close-port MKPORT)
## 	#f)
## #f
## endef
##
## $(guile $(GUILEIO))
##
## isguile :
## 	$(guile (mkopen "tmp.out" "w"))
## 	$(foreach X,$^,$(guile (mkwrite "$(X)")))
## 	$(guile (mkclose))
## 	cat < tmp.out
