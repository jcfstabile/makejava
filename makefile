#.SUFFIXES: .java .class

main = HelloWorldApp.java
sources = Bicycle.java
sources += Car.java

HelloWorldApp.class : $(main) $(sources:.java=.class)
	javac HelloWorldApp.java

%.class : %.java
	javac $<

clean:
	rm *.class

#.class: Bicycle.java HelloWorldApp.java  
