#.SUFFIXES: .java .class
.PHONY: clean build run test

main = Vehicle.java
sources =
sources += Bicycle.java
sources += Car.java
sources += Tests.java
classpath = .:/usr/share/java/junit4.jar
testclass = Tests

build: $(sources:.java=.class) $(main:.java=.class)
	@echo Build done

%.class : %.java
	javac -cp $(classpath) $<

clean:
	rm *.class

run: $(main:.java=.class)
	@java -cp $(classpath) $(main:.java=)

test: build
	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass)
