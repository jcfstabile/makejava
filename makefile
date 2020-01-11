#.SUFFIXES: .java .class
.PHONY: clean build run 

main = HelloWorldApp.java
sources =
sources += Bicycle.java
sources += Car.java

build: $(sources:.java=.class) $(main:.java=.class)
	@echo Build done

%.class : %.java
	javac $<

clean:
	rm *.class

run: $(main:.java=.class)
	@java $(main:.java=)
