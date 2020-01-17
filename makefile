#.SUFFIXES: .java .class
.PHONY: clean build run test

#donde buscar los prerequisitos (separados por blanks o colons)
# subdirs que coincidaran con los nombres de los *package*
VPATH = 

#java file (con el .java) donde este el main ,si no hay, dejar: main = 
main = Vehicle.java

#java files (con el .java)
sources = $(main) 
sources += Bicycle.java
sources += Car.java
sources += Tests.java

#Test class (sin .class)
testclass = Tests

#donde esten los prereq iran a parar las clases...
#por eso el VPATH
classpath = .:$(VPATH):/usr/share/java/junit4.jar

build: $(sources:.java=.class)
	@echo Build done

%.class : %.java
	javac -cp $(classpath) $<

# https://unix.stackexchange.com/a/116390/103956
clean:
	find . -type f -name '*.class' -exec rm -v {} +

run: $(main:.java=.class)
	@java -cp $(classpath) $(main:.java=)

test: build
	@java -cp $(classpath) org.junit.runner.JUnitCore $(testclass)
