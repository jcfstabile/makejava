#.SUFFIXES: .java .class

main = HelloWorldApp.java
sources =
sources += Bicycle.java
sources += Car.java

HelloWorldApp.class : $(main) $(sources:.java=.class)
	javac HelloWorldApp.java

%.class : %.java
	javac $<

clean:
	rm *.class

run: $(main:.java=.class)
	java $(main:.java=)

#.class: Bicycle.java HelloWorldApp.java  
