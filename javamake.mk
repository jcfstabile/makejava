#!/usr/bin/make -f
#
# template start
.PHONY: clean build run test
# Donde esten los prerequisitos iran a parar las clases... por eso VPATH
classpath = .:$(VPATH):/usr/share/java/junit4.jar

build: $(sources:.java=.class)
	@echo build done

%.class : %.java
	javac -cp $(classpath) $<

clean:
	find -name '*.class' -exec rm -v {} \+

run: $(main:.java=.class)
	@java -cp $(classpath) $(main:.java=)

test: build
	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass)

### genera un makefile configurado automaticamente
auto:
	@echo "# makefile autoconfigurado on $(CURDIR)" > makefile
	@echo VPATH = $(shell find -name '*.java' | sed 's%^.*/\(.*\)/.*$$%\1%g' | uniq | paste -sd':' ) >> makefile
	@echo main = $(shell grep -r 'main.*String' */*.java | sed 's#^.*/\(.*java\):.*$$#\1#g' ) >> makefile
	@echo sources = \$$\(main\) $(shell find -name '*.java' | sed 's#^.*/\(.*\)$$#\1#g' | paste -sd' ') >> makefile
	@echo testclass = $(shell grep -H -r "import[[:space:]]*static[[:space:]]*org.junit" tests/*.java | sed 's#^tests/\(.*\)\.java:.*$$#\1#g') >> makefile
	@cat javamake.mk >> makefile
	@make
