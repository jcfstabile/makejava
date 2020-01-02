#.SUFFIXES: .java .class
.PHONY: clean run 

main = HelloWorldApp.java
sources =
sources += Bicycle.java
sources += Car.java

build: $(main:.java=.class)

%.class : %.java
	javac $<

clean:
	rm *.class

run: $(main:.java=.class)
	@java $(main:.java=)
