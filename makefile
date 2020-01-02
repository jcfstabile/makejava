#.SUFFIXES: .java .class
.PHONY: clean run 

main = HelloWorldApp.java
sources =
sources += Bicycle.java
sources += Car.java

build: $(main:.java=.class)

#$(main:.java=.class) : $(main) $(sources:.java=.class)
#	javac $(main)

%.class : %.java
	javac $<

clean:
	rm *.class

run: $(main:.java=.class)
	@java $(main:.java=)
