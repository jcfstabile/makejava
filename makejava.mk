#!/usr/bin/make -f
#
# template start
.PHONY: build clean run test
# bin existe
classpath = .:bin:src:/usr/share/java/junit4.jar
vpath %.class $(subst src,bin,$(VPATH)):bin

build: $(sources:.java=.class)
	@echo build done

%.class: %.java
	javac -d bin -cp $(classpath) $<

clean:
	find bin -name '*.class' -exec rm -v {} \+

run: $(main:.java=.class)
	@java -cp $(classpath) $(main:.java=)

test: build
	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass)

### genera un makefile configurado automaticamente
auto:
	@echo "# makefile autoconfigurado on $(CURDIR)" > makefile
	@echo VPATH = $(shell find -name '*.java' | sed 's%^\./\(.*\)/.*$$%\1%g' | uniq | paste -sd':' ) >> makefile
	@echo main = $(shell grep -H -r 'main.*String' */*.java | sed 's#^.*/\(.*java\):.*$$#\1#g' ) >> makefile
	@echo sources = \$$\(main\) $(shell find -name '*.java' | sed 's#^.*/\(.*\)$$#\1#g' | paste -sd' ') >> makefile
	@echo testclass = $(shell grep -H -r "import[[:space:]]*org.junit.Test;" tests/*.java | sed 's#^tests/\(.*\)\.java:.*$$#\1#g') >> makefile
	@cat makejava.mk >> makefile
	@make
