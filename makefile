#.SUFFIXES: .java .class
.PHONY: clean build run 

main = HelloWorldApp.java
sources =
sources += Bicycle.java
sources += Car.java

build: $(main:.java=.class)

%.class : %.java
	javac $<
	@echo $<

clean:
	rm *.class

run: $(main:.java=.class)
	@java $(main:.java=)
