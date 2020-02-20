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

build: bin/ lib/junit-platform-console-standalone-1.6.0.jar $(sources:.java=.class) 
	@echo "\e[92mBuild done.\e[0m"

bin/ :
	mkdir -p bin

lib/junit-platform-console-standalone-1.6.0.jar :
	@echo "\e[92mDownloading junit 5 platform console:\e[0m" 
	@mkdir -p lib
	@wget -nv -P lib https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.6.0/junit-platform-console-standalone-1.6.0.jar

%.class: %.java
	javac -d bin -cp $(classpath) $<

clean:
	@echo "\e[92mCleaning bin dir:\e[0m" 
	find bin -name '*.class' -exec rm -v {} \+

run: build $(mainclass:=.class)
ifneq ($(strip $(mainclass)),)
	@echo "\e[92mRunning main method found:\e[0m" 
	@java -cp $(classpath) $(mainfqn)
else
	@echo "\e[93mNo main method found.\e[0m" 
endif

test: build
	@echo "\e[92mRunning tests:\e[0m" 
	java -jar lib/* -cp $(classpath) --scan-class-path | sed '/^[[ ] .*/d'

check :
	@echo "\e[91mVPATH\e[0m" $(VPATH)
	@echo "\e[91mmainfqn\e[0m" $(mainfqn)
	@echo "\e[91mmainclass\e[0m" $(mainclass)
	@echo "\e[91msources\e[0m" $(sources)
	@echo "\e[91mtestclass\e[0m" $(testclass)
	@echo "\e[91mclasspath\e[0m" $(classpath)


### genera un makefile configurado automaticamente
configure :
	@echo "# makefile autoconfigurado on $(CURDIR)" > makefile
	#$(MAKEFILE_LIST) is absolute path
	@cat $(MAKEFILE_LIST) >> makefile
	# makefile written on $(shell pwd)
	# use: make ; make run ; make test

tips : tipsbanner imports

tipsbanner : 
	@echo -n "\e[94m"
	@echo Basics imports needed to include in test classes
	@echo "ie. insert easily with: \e[95m make imports >> src/ClassTests.java"
	@echo -n "\e[0m"

imports :
	@echo import static org.junit.jupiter.api.Assertions.assertArrayEquals;
	@echo import static org.junit.jupiter.api.Assertions.assertEquals;
	@echo import org.junit.jupiter.api.Test;
	@echo import org.junit.jupiter.api.BeforeEach;

